Administrator.create!(account: 'admin', password: '123456', password_confirmation: '123456', name: '管理员')
Version.create!([
  { major: 0, minor: 0, point: 1, build: '4BC01F', content: '初始化项目', state: :published },
  { major: 0, minor: 0, point: 2, build: '97EDA2', content: '构建基础框架', state: :published },
  { major: 0, minor: 0, point: 3, build: 'CF805F', content: '重构用户体系', state: :published },
  { major: 0, minor: 0, point: 4, build: 'CF805F', content: '构建API框架', state: :published },
  { major: 0, minor: 0, point: 5, build: 'BA7F28', content: '实现营业流程管理', state: :published }
])