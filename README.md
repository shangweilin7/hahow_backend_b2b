## 如何執行 server：
  此 server 為 graphql server，API 為：
    `POST https://hahow-backend-b2b-8d02f5abd556.herokuapp.com/graphql`
  - 拿取所有 courses
```
query GetCourses {
  courses {
    id
    name
    lecturer
    description
    chapters {
      id
      name
      position
      units {
        id
        name
        description
        content
        position
      }
    }
  }
}
```
  - 拿取特定 course
```
query GetCourse($id: Int!) {
  course(id: $id) {
    id
    name
    lecturer
    description
    chapters {
      id
      name
      position
      units {
        id
        name
        description
        content
        position
      }
    }
  }
}
```
  - 新增 course
```
mutation CreateCourse($attributes: CourseInputs!) {
  createCourse(input: {
    attributes: $attributes
  }) {
    course {
      id
      name
      lecturer
      description
      chapters {
        id
        name
        position
        units {
          id
          name
          description
          content
          position
        }
      }
    }
  }
}

// variables
{
  "attributes": {
    "name": "course",
    "lecturer": "lecturer name",
    "description": "description",
    "chaptersAttributes": [{
      "name": "chapter name 1",
      "position": 0,
      "unitsAttributes": [{
        "name": "unit name 1",
        "description": "description",
        "content": "content",
        "position": 0
      }, {
        "name": "unit name 2",
        "description": "description",
        "content": "content",
        "position": 1
      }]
    }, {
        "name": "chapter name 2",
        "position": 1,
        "unitsAttributes": [{
          "name": "unit name 1",
          "description": "description",
          "content": "content",
          "position": 0
        }, {
          "name": "unit name 2",
          "description": "description",
          "content": "content",
          "position": 1
        }]
    }]
  }
}
```
  - 編輯 course
```
mutation UpdateCourse($id: Int!, $attributes: CourseInputs!) {
  updateCourse(input: {
    id: $id,
    attributes: $attributes
  }) {
    course {
      id
      name
      lecturer
      description
      chapters {
        id
        name
        position
        units {
          id
          name
          description
          content
          position
        }
      }
    }
  }
}

// variables
{
  "id": 1,
  "attributes": {
    "name": "course edit",
    "lecturer": "lecturer name edit",
    "description": "description edit",
    "chaptersAttributes": [{
      "id": 1,
      "name": "chapter name 2",
      "position": 0,
      "unitsAttributes": [{
        "id": 1,
        "name": "unit name 1",
        "description": "description",
        "content": "content",
        "position": 1
      }, {
        "id": 2,
        "name": "unit name 2",
        "description": "description",
        "content": "content",
        "position": 0
      }]
    }, {
      "id": 2,
      "name": "chapter name 3",
      "position": 1,
      "unitsAttributes": [{
        "id": 3,
        "name": "unit name 2",
        "description": "description",
        "content": "content",
        "position": 1
      }, {
        "id": 4,
        "_destroy": true
      }]
    }]
  }
}
```
  - 刪除 course
```
mutation DestroyCourse($id: Int!) {
  destroyCourse(input: { id: $id }) {
    id
  }
}

// variables
{
  "id": 1
}
```

## 專案架構：
  - Ruby version: 3.3.4
  - Ruby on Rails version: 7.1.3
  - 專案架構採用 graphql server 去架設
  - 使用 rails accepts_nested_attributes_for 讓 course 可同步新增 chapters & units
  - 使用 graphql 架構去限制使用者輸入的資料類型
  - 使用 GraphQL::Dataloader(`Sources::Association`) 去解決 N+1 的問題
  - graphql schema 可參考 schema.graphql 檔案
  - 採用 rescue_from 去攔截並丟出錯誤訊息(errors -> message)
  - 額外多新增了幾個 validates：
    - course 底下的 chapters 不能有相同的 name & position
    - chapter 底下的 units 不能有相同的 name & position

## API 架構邏輯：
  - query courses((Types::CourseType -> Types::ChapterType -> Types::UnitType))
    - 用於 query 多個 courses，可以一併 query course 底下的 chapters & units
  - query course(id: ID) (Types::CourseType -> Types::ChapterType -> Types::UnitType)
    - 用於 query 單一 course，可以一併 query course 底下的 chapters & units
  - mutation createCourse(input: { attributes: CourseInputs! }) (Mutations::CreateCourse)
    - 用於新增 course 跟底下的 chapters & units
  - mutation updateCourse(input: { id: Int!, attributes: CourseInputs! }) (Mutations::UpdateCourse)
    - 用於編輯 course 跟底下的 chapters & units（也可以通過 `_destroy: true` 來刪除特定的 chapter or unit）
  - mutation destroyCourse(input: { id: Int! }) (Mutations::DestroyCourse)
    - 用於刪除 course 跟底下的 chapters & units
  - API 的錯誤訊息會出現在 errors -> message

## 使用的第三方 gems 與介紹：
  - graphql
    - 用來架設整個 graphql server 的套件
  - pg
    - 用於跟 postgresql database 溝通的套件
  - factory_bot_rails
    - 用於新增測試的假資料，也可避免撰寫過長的測試
  - database_cleaner-active_record
    - 用於每次跑測試時都能還原成新的 database 的套件，避免資料的累加造成不同的測試間互相干擾
  - shoulda-matchers
    - 用於簡化常見的 rails 測試，避免撰寫過長、過於複雜的測試
  - rubocop
    - 用於統一 coding style，也可避免程式碼寫錯，減少 code review 的時間

## 註解原則：
  - 外部資料關聯的連結
  - 不走常規的邏輯設計，需要解釋為什麼不使用常規做法
  - 不註解 method 作用，通過好的 method 命名來取代掉註解

## 多種實作方式抉擇：
  - RESTful api vs graphql server
    - RESTful api 常常都只供應單一需求而寫，比較不容易共用，通常有新需求就會有新的 api，專案後期會導致 api 過多，難以維護的問題
    - graphql server 提供較客製化 query & mutaion，使用者可以自由拿取所需的資料
    - 沒有從 0 到 1 架設過 graphql server(只有新增 types & mutation 過)，可以順便練習
  - general validates vs custom validates(course.chapters & chapter.units 的 name & position 不能相同)
    - 原本實作 general validate(`validates :name, presence: true, uniqueness: { scope: :course_id }`)，但後來發現在使用 nested_attributes 新增 chapters，因為資料還沒存入所以 validate 會過（只會拿已存入的資料去做驗證），所以改用 custom validate 去解決這個問題

## 遇到的困難與解決方式：
  - nested_attributes 新增的資料用一般的 validate 只會查找已存在資料庫的資料做比對，所以 validate 會過，後來改用 custom validate 去拿取所有包括還沒存入的資料來做比對
