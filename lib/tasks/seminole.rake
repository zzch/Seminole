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
    bench = Benchmark.measure do
      { laipeng: '北京来鹏高尔夫练习场', star: '北京星空高尔夫练习场', huijia: '北京汇佳高尔夫练习场', sunshine: '北京日月光高尔夫练习场', cbd: '北京CBD国际高尔夫练习场', perfect: '北京珀翡高尔夫练习场' }.each do |code, name|
        Club.create!(name: name, code: code, floors: 2)
      end
      Version.create!([
        { major: 0, minor: 0, point: 1, build: '4BC01F', content: '初始化项目', state: :published },
        { major: 0, minor: 0, point: 2, build: '97EDA2', content: '构建基础框架', state: :published }
      ])
      Club.last.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..24).each{|number| club.tees.create!(name: number, floor: 1) }
        (1..8).each{|number| club.tees.create!(name: "VIP#{number}", floor: 1) }
      end
    end
    p "finished in #{bench.real} second(s)"
  end
end