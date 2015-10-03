namespace :data do
  desc 'Cleanup all data.'
  task reset: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['data:populate'].invoke
  end

  desc 'Populate fake data for testing.'
  task populate: :environment do
    Faker::Config.locale = 'zh-CN'
    bench = Benchmark.measure do
      { laipeng: '北京来鹏高尔夫练习场', star: '北京星空高尔夫练习场', huijia: '北京汇佳高尔夫练习场', sunshine: '北京日月光高尔夫练习场', cbd: '北京CBD国际高尔夫练习场', perfect: '北京珀翡高尔夫练习场' }.each do |code, name|
        Club.create!(name: name, code: code, floors: 2)
      end
      Version.create!([
        { major: 0, minor: 0, point: 1, build: '4BC01F', content: '初始化项目', state: :published },
        { major: 0, minor: 0, point: 2, build: '97EDA2', content: '构建基础框架', state: :published },
        { major: 0, minor: 0, point: 3, build: 'CF805F', content: '重构用户体系', state: :published }
      ])
      Club.last.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..24).each{|number| club.tees.create!(name: number, floor: 1) }
        (1..8).each{|number| club.tees.create!(name: "VIP#{number}", floor: 2) }
        club.cards.create!([
          { type: :by_time, name: '6800元 计时卡', price: 6800.00, total_amount: 10000, valid_months: 12, maximum_tees: 2, minute_amount: 6000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 },
          { type: :by_time, name: '12000元 计时卡', price: 12000.00, total_amount: 10000, valid_months: 24, maximum_tees: 3, minute_amount: 12000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 }
        ])
        100.times do
          club.members.create_with_user(club, Op::CreateMember.new(phone: "1#{[3, 5, 8].sample}#{Faker::Number.number(9)}", last_name: Faker::Name.first_name, first_name: Faker::Name.last_name, gender: [:male, :female].sample, card_id: club.cards.all.sample.id))
        end
        club.product_categories.create!(name: '饮品').products.create!([
          { name: '可乐', price: '6.00'},
          { name: '雪碧', price: '6.00'},
          { name: '美年达', price: '6.00'}
        ])
        club.product_categories.create!(name: '正餐').products.create!([
          { name: '宫保鸡丁', price: '48.00'},
          { name: '鱼香肉丝', price: '42.00'}
        ])
      end
    end
    p "finished in #{bench.real} second(s)"
  end
end