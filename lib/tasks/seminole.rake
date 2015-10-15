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
      { isports: '北京中创体育高尔夫练习场', star: '北京星空高尔夫练习场', huijia: '北京汇佳高尔夫练习场', sunshine: '北京日月光高尔夫练习场', cbd: '北京CBD国际高尔夫练习场', perfect: '北京珀翡高尔夫练习场' }.each do |code, name|
        Club.create!(name: name, code: code, logo: fake_image_file, floors: 2, longitude: Faker::Address.longitude, latitude: Faker::Address.latitude)
      end
      Version.create!([
        { major: 0, minor: 0, point: 1, build: '4BC01F', content: '初始化项目', state: :published },
        { major: 0, minor: 0, point: 2, build: '97EDA2', content: '构建基础框架', state: :published },
        { major: 0, minor: 0, point: 3, build: 'CF805F', content: '重构用户体系', state: :published },
        { major: 0, minor: 0, point: 4, build: 'CF805F', content: '构建API框架', state: :published }
      ])
      Club.last.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..24).each{|number| club.vacancies.create!(name: number, floor: 1) }
        (1..8).each{|number| club.vacancies.create!(name: "VIP#{number}", floor: 2) }
        club.cards.create!([
          { type: :by_time, name: '6800元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 6800.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, minute_amount: 6000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 },
          { type: :by_time, name: '12000元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 12000.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, minute_amount: 12000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 },
          { type: :by_ball, name: '9800元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 9800.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, ball_amount: 10000 },
          { type: :by_ball, name: '15800元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 15800.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, ball_amount: 20000 },
          { type: :stored, name: '49800元 储值卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 45800.00, total_amount: 2000, valid_months: 36, maximum_vacancies: 5, price_per_hour: 100, price_per_ball: 0.5, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 }
        ])
        100.times do
          member = club.members.create_with_user(club, Op::CreateMember.new(phone: "1#{[3, 5, 8].sample}#{Faker::Number.number(9)}", last_name: Faker::Name.first_name, first_name: Faker::Name.last_name, gender: [:male, :female].sample, number: rand(107180..118000), card_id: club.cards.all.sample.id))
          member.update(created_at: Time.now - rand(8000..80000).minutes)
        end
        [{ phone: 13911320927, last_name: '王', first_name: '皓' },
          { phone: 18686879306, last_name: '王', first_name: '萌' },
          { phone: 15010177980, last_name: '戴', first_name: '诚' }].each do |user|
          member = club.members.create_with_user(club, Op::CreateMember.new(phone: user[:phone], last_name: user[:last_name], first_name: user[:first_name], gender: :male, number: rand(107180..118000), card_id: club.cards.all.sample.id))
          member.update!(created_at: '2015-09-27 09:27:00')
          User.sign_in(user[:phone], 8888)
        end
        club.provision_categories.create!(name: '饮品').provisions.create!([
          { serial_number: 1732, name: '可乐', image: fake_image_file, price: '6.00' },
          { serial_number: 1894, name: '雪碧', image: nil, price: '6.00' },
          { serial_number: 1897, name: '美年达', image: fake_image_file, price: '6.00' }
        ])
        club.provision_categories.create!(name: '正餐').provisions.create!([
          { serial_number: 2016, name: '宫保鸡丁', image: fake_image_file, price: '48.00' },
          { serial_number: 2018, name: '鱼香肉丝', image: fake_image_file, price: '42.00' }
        ])
        club.announcements.create!([
          { title: '关于2015全国高尔夫球团体赛的补充通知', content: Faker::Lorem.sentence(20), state: :published, published_at: Time.now - rand(5..30).days }
        ])
        27.times do
          club.coaches.create!(name: Faker::Name.name, portrait: fake_image_file(allow_blank: true), gender: [:male, :female].sample, title: "#{['优秀', '精英', '', '国家级', '五星', '青少年', '金牌'].sample}教练", description: Faker::Lorem.sentence(80), featured: false)
        end
        ['入门', '技术', '心理', '战术', '综合提升'].each do |name|
          club.courses.create!(name: "#{name}课", price: rand(68..150) * 100, lessons: rand(8..14), valid_months: rand(6..12), maximum_students: rand(1..4), description: Faker::Lorem.sentence(80))
        end
        club.coaches.each do |coach|
          club.courses.sample(rand(0..5)).each do |course|
            Curriculum.create!(coach: coach, course: course)
          end
        end
      end
      Club.first.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..32).each{|number| club.vacancies.create!(name: "A#{number}", floor: 1) }
        (1..32).each{|number| club.vacancies.create!(name: "B#{number}", floor: 2) }
        club.cards.create!([
          { type: :by_time, name: '5990元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 5990.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, minute_amount: 6000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 },
          { type: :by_time, name: '12990元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 12990.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, minute_amount: 12000, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 },
          { type: :by_ball, name: '9990元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 9990.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, ball_amount: 10000 },
          { type: :by_ball, name: '15990元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 15990.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, ball_amount: 20000 },
          { type: :stored, name: '49990元 储值卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 49990.00, total_amount: 2000, valid_months: 36, maximum_vacancies: 5, price_per_hour: 100, price_per_ball: 0.5, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20 }
        ])
        User.all.each do |user|
          club.cards.all.sample(3).each do |card|
            member = club.members.create_with_user(club, Op::CreateMember.new(phone: user.phone, last_name: Faker::Name.first_name, first_name: Faker::Name.last_name, gender: [:male, :female].sample, number: rand(307180..618000), card_id: card.id))
          end
        end
        club.provision_categories.create!(name: '茶类').provisions.create!([
          { serial_number: 1923, name: '菊花', image: fake_image_file, price: '38.00' },
          { serial_number: 1925, name: '普洱', image: fake_image_file, price: '38.00' },
          { serial_number: 1927, name: '金骏眉', image: fake_image_file, price: '68.00' }
        ])
        club.provision_categories.create!(name: '酒类').provisions.create!([
          { serial_number: 2112, name: 'Duuel', image: nil, price: '38.00' },
          { serial_number: 2113, name: 'VEDETT', image: fake_image_file, price: '42.00' },
          { serial_number: 2116, name: 'CHIMAY', image: fake_image_file, price: '45.00' }
        ])
        club.announcements.create!([
          { title: '7月到店购卡有好礼相送', content: Faker::Lorem.sentence(20), state: :published, published_at: Time.now - rand(5..30).days },
          { title: '10月11日-13日球场维护', content: Faker::Lorem.sentence(20), state: :published, published_at: Time.now - rand(5..30).days },
          { title: '致会员们的一封信', content: Faker::Lorem.sentence(20), state: :published, published_at: Time.now - rand(5..30).days }
        ])
        27.times do
          club.coaches.create!(name: Faker::Name.name, portrait: fake_image_file(allow_blank: true), gender: [:male, :female].sample, title: "#{['优秀', '精英', '', '国家级', '五星', '青少年', '金牌'].sample}教练", description: Faker::Lorem.sentence(80), featured: (rand(1..10) > 8 ? true : false))
        end
        ['入门', '技术', '心理', '战术', '综合提升'].each do |name|
          club.courses.create!(name: "#{name}课", price: rand(68..150) * 100, lessons: rand(8..14), valid_months: rand(6..12), maximum_students: rand(1..4), description: Faker::Lorem.sentence(80))
        end
        club.coaches.each do |coach|
          club.courses.sample(rand(0..5)).each do |course|
            Curriculum.create!(coach: coach, course: course)
          end
        end
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  def fake_image_file options = {}
    if options[:allow_blank]
      rand(1..10) > 3 ? File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..200).to_s.rjust(3, '0')}.jpg")) : nil
    else
      File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..200).to_s.rjust(3, '0')}.jpg"))
    end
  end
end