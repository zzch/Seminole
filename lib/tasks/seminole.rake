namespace :data do
  desc 'Cleanup all data.'
  task reset: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['data:populate'].invoke
  end

  desc 'Cleanup all data.'
  task reset_perfect: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['data:perfect_init'].invoke
  end

  desc 'Populate fake data for testing.'
  task populate: :environment do
    Faker::Config.locale = 'zh-CN'
    bench = Benchmark.measure do
      { isports: '中创高尔夫', star: '北京星空高尔夫练习场', huijia: '北京汇佳高尔夫练习场', sunshine: '北京日月光高尔夫练习场', cbd: '北京CBD国际高尔夫练习场', guanlanhu: '观澜湖高尔夫' }.each do |code, name|
        Club.create!(name: name, code: code, logo: fake_image_file, floors: 2, longitude: 116, latitude: 39, address: "#{Faker::Address.city} #{Faker::Address.street_address}", phone_number: Faker::PhoneNumber.cell_phone, balls_per_bucket: 30, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20)
      end
      Version.create!([
        { major: 0, minor: 0, point: 1, build: '4BC01F', content: '初始化项目', state: :published },
        { major: 0, minor: 0, point: 2, build: '97EDA2', content: '构建基础框架', state: :published },
        { major: 0, minor: 0, point: 3, build: 'CF805F', content: '重构用户体系', state: :published },
        { major: 0, minor: 0, point: 4, build: 'CF805F', content: '构建API框架', state: :published },
        { major: 0, minor: 0, point: 5, build: 'BA7F28', content: '实现营业流程管理', state: :published }
      ])
      Club.last.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..24).each do |number|
          vacancy = club.vacancies.new(name: number, raw_tags: '普通打位,计时,计球', location: :first_floor, usual_price_per_hour: rand(16..24) * 10, holiday_price_per_hour: rand(16..24) * 10)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        (1..4).each do |number|
          vacancy = club.vacancies.new(name: "VIP#{number}", raw_tags: 'VIP小包,计时,计球', location: :second_floor, usual_price_per_hour: rand(16..24) * 10, holiday_price_per_hour: rand(16..24) * 10)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        (5..8).each do |number|
          vacancy = club.vacancies.new(name: "VIP#{number}", raw_tags: 'VIP大包,计时', location: :second_floor, usual_price_per_hour: rand(16..24) * 10, holiday_price_per_hour: rand(16..24) * 10)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        club.cards.create!([
          { type: :by_time, name: '6800元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 6800.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, hour_amount: 200 },
          { type: :by_time, name: '12000元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 12000.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, hour_amount: 400 },
          { type: :by_ball, name: '9800元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 9800.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, ball_amount: 10000 },
          { type: :by_ball, name: '15800元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 15800.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, ball_amount: 20000 },
          { type: :stored, name: '49800元 储值卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 45800.00, total_amount: 2000, valid_months: 36, maximum_vacancies: 5, deposit: 45800 }
        ])
        club.cards.each do |card|
          club.vacancy_tags.each do |vacancy_tag|
            UseRight.create!(card: card, vacancy_tag: vacancy_tag)
          end
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
          club.coaches.create!(name: Faker::Name.name, portrait: fake_image_file(allow_blank: true), gender: [:male, :female].sample, title: "#{['优秀', '精英', '', '国家级', '五星', '青少年', '金牌'].sample}教练", starting_price: rand(40..120) * 100, description: Faker::Lorem.sentence(80), featured: false)
        end
        ['入门', '技术', '心理', '战术', '综合提升'].each do |name|
          club.courses.create!(name: "#{name}课", price: rand(68..150) * 100, lessons: rand(8..14), valid_months: rand(6..12), maximum_students: rand(1..4), description: Faker::Lorem.sentence(80))
        end
        club.coaches.each do |coach|
          club.courses.sample(rand(0..5)).each do |course|
            Curriculum.create!(coach: coach, course: course)
          end
        end
        10.times do
          club.salesmen.create!(name: Faker::Name.name)
        end
        3.times do
          club.promotions.create!(image: fake_image_file, title: "#{(Time.now - rand(10..100).days).strftime('%m月%d日')}商城活动公告", content: Faker::Lorem.sentence(80), published_at: Time.now - rand(100..5000).minutes, state: :published)
        end
        100.times do
          member = club.members.create_with_user(club, Op::CreateMember.new(phone: "1#{[3, 5, 8].sample}#{Faker::Number.number(9)}", last_name: Faker::Name.first_name, first_name: Faker::Name.last_name, gender: [:male, :female].sample, number: rand(107180..118000), card_id: club.cards.sample.id))
          member.update(created_at: Time.now - rand(8000..80000).minutes)
        end
        [{ phone: 13911320927, last_name: '王', first_name: '皓' },
          { phone: 18686879306, last_name: '王', first_name: '萌' },
          { phone: 15010177980, last_name: '戴', first_name: '诚' }].each do |user|
          member = club.members.create_with_user(club, Op::CreateMember.new(phone: user[:phone], last_name: user[:last_name], first_name: user[:first_name], gender: :male, number: rand(107180..118000), card_id: club.cards.sample.id))
          member.update!(created_at: '2015-09-27 09:27:00')
          fake_tabs(user: User.where(phone: user[:phone]).first, club: club)
          User.sign_in(user[:phone], 8888)
        end
      end
      Club.first.tap do |club|
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        (1..32).each{|number| club.vacancies.create!(name: "A#{number}", location: :first_floor, usual_price_per_hour: rand(16..24) * 10, holiday_price_per_hour: rand(16..24) * 10) }
        (1..32).each{|number| club.vacancies.create!(name: "B#{number}", location: :second_floor, usual_price_per_hour: rand(16..24) * 10, holiday_price_per_hour: rand(16..24) * 10) }
        club.cards.create!([
          { type: :by_time, name: '5990元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 5990.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, hour_amount: 200 },
          { type: :by_time, name: '12990元 计时卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 12990.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, hour_amount: 400 },
          { type: :by_ball, name: '9990元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 9990.00, total_amount: 10000, valid_months: 12, maximum_vacancies: 2, ball_amount: 10000 },
          { type: :by_ball, name: '15990元 计球卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 15990.00, total_amount: 10000, valid_months: 24, maximum_vacancies: 3, ball_amount: 20000 },
          { type: :stored, name: '49990元 储值卡', background_color: Faker::Number.hexadecimal(6), font_color: Faker::Number.hexadecimal(6), price: 49990.00, total_amount: 2000, valid_months: 36, maximum_vacancies: 5, deposit: 49990 }
        ])
        User.all.each do |user|
          club.cards.sample(3).each do |card|
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
          club.coaches.create!(name: Faker::Name.name, portrait: fake_image_file(allow_blank: true), gender: [:male, :female].sample, title: "#{['优秀', '精英', '', '国家级', '五星', '青少年', '金牌'].sample}教练", starting_price: rand(40..120) * 100, description: Faker::Lorem.sentence(80), featured: (rand(1..10) > 8 ? true : false))
        end
        ['入门', '技术', '心理', '战术', '综合提升'].each do |name|
          club.courses.create!(name: "#{name}课", price: rand(68..150) * 100, lessons: rand(8..14), valid_months: rand(6..12), maximum_students: rand(1..4), description: Faker::Lorem.sentence(80))
        end
        club.coaches.each do |coach|
          club.courses.sample(rand(0..5)).each do |course|
            Curriculum.create!(coach: coach, course: course)
          end
        end
        10.times do
          club.salesmen.create!(name: Faker::Name.name)
        end
        50.times do
          club.promotions.create!(image: fake_image_file, title: "#{(Time.now - rand(10..100).days).strftime('%m月%d日')}商城活动公告", content: Faker::Lorem.sentence(80), published_at: Time.now - rand(100..5000).minutes, state: :published)
        end
      end
      Weather.fetch
    end
    p "finished in #{bench.real} second(s)"
  end

  desc 'Initialize data for Perfect Driving Range.'
  task perfect_init: :environment do
    bench = Benchmark.measure do
      ActiveRecord::Base.transaction do
        club = Club.create!(name: '北京珀翡高尔夫俱乐部', short_name: '珀翡高尔夫', code: 'perfect', floors: 2, longitude: 116.521022, latitude: 39.977470, address: '北京市朝阳区将台路1号 将府花园', phone_number: '13911320927', balls_per_bucket: 30, minimum_charging_minutes: 20, unit_charging_minutes: 60, maximum_discard_minutes: 20)
        club.operators.create!(account: 'wanghao', password: '123456', password_confirmation: '123456', name: '王皓', omnipotent: true)
        club.operators.create!(account: 'test', password: 'test', password_confirmation: 'test', name: '测试账号', omnipotent: false)
        (1..24).each do |number|
          vacancy = club.vacancies.new(name: "#{number}号", raw_tags: '普通打位', location: :first_floor, usual_price_per_hour: 200, holiday_price_per_hour: 200)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        (1..2).each do |number|
          vacancy = club.vacancies.new(name: "小#{number}", raw_tags: 'VIP小包', location: :second_floor, usual_price_per_hour: 400, holiday_price_per_hour: 400)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        (1..3).each do |number|
          vacancy = club.vacancies.new(name: "中#{number}", raw_tags: 'VIP中包', location: :second_floor, usual_price_per_hour: 600, holiday_price_per_hour: 600)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        (1..3).each do |number|
          vacancy = club.vacancies.new(name: "大#{number}", raw_tags: 'VIP大包', location: :second_floor, usual_price_per_hour: 800, holiday_price_per_hour: 800)
          vacancy.save!
          vacancy.reset_tags_by_raw_string
        end
        regular_tag = VacancyTag.where(club_id: club.id, name: '普通打位').first
        vip_sm_tag = VacancyTag.where(club_id: club.id, name: 'VIP小包').first
        vip_md_tag = VacancyTag.where(club_id: club.id, name: 'VIP中包').first
        vip_lg_tag = VacancyTag.where(club_id: club.id, name: 'VIP大包').first
        ################  19800储值卡(2年) (7人) 
        club.cards.create!(type: :stored, name: '19800储值卡(2年)', background_color: '298c2e', font_color: 'ffffff', price: 19800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 19800, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 40, holiday_price_per_bucket: 40)
          end
          [{ number: 'J0100', last_name: '陈', first_name: '秋霞', gender: :female, phone: '18610486511' },
          { number: 'J0102', last_name: '闫', first_name: '佩晴', gender: :female, phone: '13901362345' },
          { number: 'J0103', last_name: '刘', first_name: '畅', gender: :female, phone: '18911011819' },
          { number: 'J0104', last_name: '蔡', first_name: '敏', gender: :male, phone: '13331017389' },
          { number: 'J0110', last_name: '张', first_name: '振迪', gender: :male, phone: '15600002310' },
          { number: 'J0111', last_name: '朱', first_name: '飞', gender: :male, phone: '18612561777' },
          { number: 'J0117', last_name: '郑', first_name: '伟', gender: :male, phone: '13910226633' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  19800钻石储值卡/筐 (5人)
        club.cards.create!(type: :stored, name: '19800钻石储值卡/框', background_color: '298c2e', font_color: 'ffffff', price: 19800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 19800, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 13, holiday_price_per_bucket: 13)
          end
          [{ number: 'B0002', last_name: '刘', first_name: '雷', gender: :male, phone: '' },
          { number: 'B0003', last_name: '董', first_name: '纯钢', gender: :male, phone: '' },
          { number: 'B0004', last_name: '李', first_name: '志勇', gender: :male, phone: '18618420246' },
          { number: 'J0030', last_name: '张', first_name: '志新', gender: :male, phone: '13910872767' },
          { number: 'J0052', last_name: '阿', first_name: '炳', gender: :male, phone: '18610531490' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  25000（VIP包房卡） (2人)
        club.cards.create!(type: :unlimited, name: '25000（VIP包房卡）', background_color: '298c2e', font_color: 'ffffff', price: 25000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, maximum_daily_hours: 6, vacancy_tag_ids: [vip_sm_tag.id, vip_md_tag.id, vip_lg_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0112', last_name: '郭', first_name: '志东', gender: :male, phone: '13474880888' },
          { number: 'J0120', last_name: '杜', first_name: '淼', gender: :male, phone: '13701113711' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  25000储值卡 (1人)
        club.cards.create!(type: :stored, name: '25000储值卡', background_color: '298c2e', font_color: 'ffffff', price: 25000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 25000, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_hour: 80, holiday_price_per_hour: 80)
          end
          [{ number: 'J0106', last_name: '何', first_name: '家兴', gender: :male, phone: '13901052597' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  3000套票/12个月 (6人)
        club.cards.create!(type: :by_ball, name: '3000套票/12个月', background_color: '298c2e', font_color: 'ffffff', price: 3000, total_amount: 0, valid_months: 12, maximum_vacancies: 0, ball_amount: 5280,vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0011', last_name: '王', first_name: '虹', gender: :male, phone: '' },
          { number: 'J0057', last_name: '王', first_name: '强', gender: :male, phone: '' },
          { number: 'J0064', last_name: '丁', first_name: '乐', gender: :male, phone: '13801046335' },
          { number: 'J0067', last_name: '夏', first_name: '宇', gender: :male, phone: '18618307054' },
          { number: 'J0081', last_name: '邢', first_name: '克生', gender: :male, phone: '13910561199' },
          { number: 'J0089', last_name: '金', first_name: '璐', gender: :male, phone: '13811104487' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  3400/筐 (1人)
        club.cards.create!(type: :by_ball, name: '3000套票/12个月', background_color: '298c2e', font_color: 'ffffff', price: 3400, total_amount: 0, valid_months: 12, maximum_vacancies: 0, ball_amount: 7020, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0018', last_name: '张', first_name: '力元', gender: :male, phone: '18500030556' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  49800储值卡（3年） (1人)
        club.cards.create!(type: :stored, name: '49800储值卡（3年）', background_color: '298c2e', font_color: 'ffffff', price: 49800, total_amount: 0, valid_months: 36, maximum_vacancies: 0, deposit: 49800, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_hour: 60, holiday_price_per_hour: 60)
          end
          [{ number: 'J0124', last_name: '罗', first_name: '', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  5800银卡储值卡/（筐） (29人)
        club.cards.create!(type: :stored, name: '5800银卡储值卡/（筐）', background_color: '298c2e', font_color: 'ffffff', price: 5800, total_amount: 0, valid_months: 12, maximum_vacancies: 0, deposit: 5800, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 20, holiday_price_per_bucket: 20)
          end
          [{ number: 'B5800', last_name: '徐', first_name: '建华', gender: :male, phone: '13825013392' },
          { number: 'J0013', last_name: '李', first_name: '昕', gender: :male, phone: '' },
          { number: 'J0016', last_name: '李', first_name: '彪', gender: :male, phone: '13901042272' },
          { number: 'J0020', last_name: '夏', first_name: '林聪', gender: :female, phone: '' },
          { number: 'J0022', last_name: '光', first_name: '晓刚', gender: :male, phone: '13161622908' },
          { number: 'J0023', last_name: '秦', first_name: '雅南', gender: :female, phone: '18710173732' },
          { number: 'J0038', last_name: '马', first_name: '微', gender: :female, phone: '18611177470' },
          { number: 'J0041', last_name: '李', first_name: '楠', gender: :female, phone: '18633131222' },
          { number: 'J0044', last_name: '陈', first_name: '贤卓', gender: :male, phone: '13910077811' },
          { number: 'J0046', last_name: '张', first_name: '学超', gender: :male, phone: '13910409527' },
          { number: 'J0047', last_name: '喻', first_name: '晓峰', gender: :male, phone: '' },
          { number: 'J0048', last_name: '石', first_name: '嵩', gender: :male, phone: '13901152729' },
          { number: 'J0060', last_name: '李', first_name: '永亮', gender: :male, phone: '13436366197' },
          { number: 'J0062', last_name: '刘', first_name: '霜', gender: :female, phone: '' },
          { number: 'J0065', last_name: '石', first_name: '铭远', gender: :male, phone: '13001031127' },
          { number: 'J0068', last_name: '吴', first_name: '迪', gender: :male, phone: '' },
          { number: 'J0069', last_name: '李', first_name: '俊生', gender: :male, phone: '13311218416' },
          { number: 'J0070', last_name: '木村', first_name: '哲郎', gender: :male, phone: '13311096597' },
          { number: 'J0071', last_name: '凌', first_name: '蓉', gender: :female, phone: '13701393217' },
          { number: 'J0072', last_name: '郭', first_name: '立军', gender: :male, phone: '' },
          { number: 'J0073', last_name: '姚', first_name: '玥', gender: :female, phone: '' },
          { number: 'J0075', last_name: '张', first_name: '韦', gender: :female, phone: '' },
          { number: 'J0076', last_name: '任', first_name: '永强', gender: :male, phone: '' },
          { number: 'J0078', last_name: '杨', first_name: '炳新', gender: :male, phone: '' },
          { number: 'J0080', last_name: '徐', first_name: '镭', gender: :male, phone: '' },
          { number: 'J0083', last_name: '聂', first_name: '涛', gender: :male, phone: '13910821115' },
          { number: 'J0086', last_name: '王', first_name: '重阳', gender: :male, phone: '18500226970' },
          { number: 'J0088', last_name: '王', first_name: '珏', gender: :male, phone: '13916627277' },
          { number: 'J0090', last_name: '伍', first_name: '秋乾', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  9800/计球卡 (7人)
        club.cards.create!(type: :by_ball, name: '9800/计球卡', background_color: '298c2e', font_color: 'ffffff', price: 9800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, ball_amount: 20000, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0105', last_name: '葛', first_name: '鹏', gender: :male, phone: '13911656130' },
          { number: 'J0107', last_name: '杨', first_name: '志敏', gender: :male, phone: '13701033184' },
          { number: 'J0108', last_name: '陈', first_name: '静颖', gender: :female, phone: '13311154471' },
          { number: 'J0109', last_name: '白', first_name: '云鹏', gender: :male, phone: '13810128083' },
          { number: 'J0119', last_name: '何', first_name: '汀', gender: :male, phone: '18610750896' },
          { number: 'J0121', last_name: '朱', first_name: '立维', gender: :male, phone: '18911008529' },
          { number: 'J0122', last_name: '尹', first_name: '吉根', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  9800个人记名（年卡） (1人)
        club.cards.create!(type: :unlimited, name: '9800个人记名（年卡）', background_color: '298c2e', font_color: 'ffffff', price: 9800, total_amount: 0, valid_months: 24, maximum_vacancies: 1, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0113', last_name: '程', first_name: '韶蓬', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  9800金卡储值卡/（筐） (23人)
        club.cards.create!(type: :stored, name: '9800金卡储值卡/（筐）', background_color: '298c2e', font_color: 'ffffff', price: 9800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 9800, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 17, holiday_price_per_bucket: 17)
          end
          [{ number: 'J0014', last_name: '刘', first_name: '海成', gender: :male, phone: '13693387123' },
          { number: 'J0017', last_name: '张', first_name: '杭', gender: :male, phone: '15801033331' },
          { number: 'J0025', last_name: '吴', first_name: '易轩', gender: :male, phone: '13910956756' },
          { number: 'J0031', last_name: '李', first_name: '健辉', gender: :male, phone: '18901118998' },
          { number: 'J0032', last_name: '张', first_name: '鹏', gender: :male, phone: '18631106666' },
          { number: 'J0034', last_name: '暴', first_name: '子睿', gender: :female, phone: '13521113000' },
          { number: 'J0039', last_name: '李', first_name: '程', gender: :male, phone: '13910187081' },
          { number: 'J0045', last_name: '张', first_name: '磊', gender: :male, phone: '18618406838' },
          { number: 'J0049', last_name: '凌', first_name: '平', gender: :male, phone: '' },
          { number: 'J0050', last_name: '顾', first_name: '青', gender: :male, phone: '18618145070' },
          { number: 'J0051', last_name: '李', first_name: '国栋', gender: :male, phone: '' },
          { number: 'J0053', last_name: '李', first_name: '斌', gender: :male, phone: '13292881388' },
          { number: 'J0055', last_name: '孙', gender: :male, phone: '13621271756' },
          { number: 'J0059', last_name: '刘', first_name: '雷', gender: :male, phone: '' },
          { number: 'J0063', last_name: '陶', first_name: '然', gender: :female, phone: '18901196187' },
          { number: 'J0077', last_name: '叶', first_name: '珊珊', gender: :female, phone: '18659368888' },
          { number: 'J0079', last_name: '张', first_name: '琳', gender: :female, phone: '' },
          { number: 'J0082', last_name: '王', first_name: '禹', gender: :male, phone: '' },
          { number: 'J0084', last_name: '张', first_name: '虹涛', gender: :male, phone: '13911031813' },
          { number: 'J0085', last_name: '韩', first_name: '唯日', gender: :male, phone: '13901086360' },
          { number: 'J0087', last_name: '李', first_name: '兵现', gender: :male, phone: '' },
          { number: 'J0091', last_name: '吴', first_name: '冰', gender: :male, phone: '15901017815' },
          { number: 'J0099', last_name: '郭', first_name: '书坤', gender: :male, phone: '18911961718' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  VIP储值卡30000 (1人)
        club.cards.create!(type: :unlimited, name: '3VIP储值卡30000', background_color: '298c2e', font_color: 'ffffff', price: 30000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'B0001', last_name: '季', first_name: '飞', gender: :male, phone: '13321107229' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  VIP储值卡50000 (2人)
        club.cards.create!(type: :unlimited, name: 'VIP储值卡50000', background_color: '298c2e', font_color: 'ffffff', price: 50000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'B0012', last_name: '何', first_name: '武', gender: :male, phone: '' },
          { number: 'H0001', last_name: '周', first_name: '井玉', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  百度20000 (1人)
        club.cards.create!(type: :stored, name: '百度20000', background_color: '298c2e', font_color: 'ffffff', price: 20000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 20000, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 12, holiday_price_per_bucket: 12)
          end
          [{ number: 'J0127', last_name: '文', first_name: '安迪', gender: :male, phone: '13693608555' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  储值卡10000 (3人)
        club.cards.create!(type: :stored, name: '储值卡10000', background_color: '298c2e', font_color: 'ffffff', price: 10000, total_amount: 0, valid_months: 24, maximum_vacancies: 0, deposit: 10000, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          club.vacancies.location_first_floors.each do |vacancy|
            card.vacancy_prices.create!(vacancy: vacancy, usual_price_per_bucket: 17, holiday_price_per_bucket: 17)
          end
          [{ number: 'J0003', last_name: '魏', first_name: '海涛', gender: :male, phone: '13901225523' },
          { number: 'J0027', last_name: '吴', first_name: '宝清', gender: :male, phone: '18610800000' },
          { number: 'J0028', last_name: '王', first_name: '治森', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  计次卡6800 (12人)
        club.cards.create!(type: :by_ball, name: '计次卡6800', background_color: '298c2e', font_color: 'ffffff', price: 6800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, ball_amount: 14010, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0002', last_name: '王', first_name: '志宏', gender: :male, phone: '13701074967' },
          { number: 'J0004', last_name: '杨', first_name: '志敏', gender: :male, phone: '13701033184' },
          { number: 'J0006', last_name: '刘', first_name: '兴光', gender: :male, phone: '15810004399' },
          { number: 'J0010', last_name: '赵', first_name: '晓溟', gender: :male, phone: '' },
          { number: 'J0015', last_name: '邢', gender: :male, phone: '13901062258' },
          { number: 'J0019', last_name: '葛', first_name: '鹏', gender: :male, phone: '13911656130' },
          { number: 'J0024', last_name: '张', first_name: '硕青', gender: :female, phone: '13581985689' },
          { number: 'J0033', last_name: '王', first_name: '智', gender: :male, phone: '13901079116' },
          { number: 'J0037', last_name: '于', first_name: '晓纯', gender: :male, phone: '13910592736' },
          { number: 'J0054', last_name: '赵', first_name: '涛', gender: :male, phone: '15035272222' },
          { number: 'J0056', last_name: '王', first_name: '有运', gender: :male, phone: '13377521118' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        ################  年卡12800 (4人)
        club.cards.create!(type: :unlimited, name: '年卡12800', background_color: '298c2e', font_color: 'ffffff', price: 12800, total_amount: 0, valid_months: 24, maximum_vacancies: 0, vacancy_tag_ids: [regular_tag.id]).tap do |card|
          card.reset_use_rights_by_vacancy_tag_ids
          [{ number: 'J0005', last_name: '查', first_name: '理', gender: :male, phone: '18601190559' },
          { number: 'J0007', last_name: '徐', first_name: '楠', gender: :male, phone: '13910300130' },
          { number: 'J0012', last_name: '杨', first_name: '铮', gender: :male, phone: '13911382890' },
          { number: 'J0036', last_name: '王', first_name: '建国', gender: :male, phone: '' }].each do |member|
            club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
          end
        end
        club.provision_categories.create!(name: '饮品').provisions.create!([
          { serial_number: 1001, name: '尖叫', image: nil, price: '10.00' },
          { serial_number: 1002, name: '脉动', image: nil, price: '10.00' },
          { serial_number: 1003, name: '苏打水', image: nil, price: '10.00' },
          { serial_number: 1004, name: '红牛', image: nil, price: '15.00' },
          { serial_number: 1005, name: '矿泉水', image: nil, price: '6.00' },
          { serial_number: 1006, name: '王老吉', image: nil, price: '8.00' },
          { serial_number: 1007, name: '可乐(听)', image: nil, price: '5.00' },
          { serial_number: 1008, name: '雪碧(听)', image: nil, price: '5.00' }
        ])
        club.provision_categories.create!(name: '简餐').provisions.create!([
          { serial_number: 2001, name: '牛肉套餐', image: nil, price: '48.00' },
          { serial_number: 2002, name: '咖喱鸡肉套餐', image: nil, price: '38.00' },
          { serial_number: 2003, name: '麻婆豆腐饭套餐', image: nil, price: '28.00' },
          { serial_number: 2004, name: '西红柿鸡蛋饭套餐', image: nil, price: '28.00' },
          { serial_number: 2005, name: '炒面', image: nil, price: '18.00' },
          { serial_number: 2006, name: '蔬菜沙拉', image: nil, price: '18.00' },
          { serial_number: 2007, name: '牛肉面', image: nil, price: '38.00' },
          { serial_number: 2008, name: '炸酱面', image: nil, price: '28.00' },
          { serial_number: 2009, name: '西红柿鸡蛋面', image: nil, price: '26.00' },
          { serial_number: 2010, name: '扬州炒饭', image: nil, price: '18.00' },
          { serial_number: 2011, name: '鸡蛋炒饭', image: nil, price: '18.00' }
        ])
      end
    end
  end

  desc 'Initialize data for Green Driving Range.'
  task green_init: :environment do
    club = Club.where(code: 'perfect').first
    regular_tag = VacancyTag.where(club_id: club.id, name: '普通打位').first
    ################  绿色印象卡/计球卡 (7人)
    club.cards.create!(type: :by_ball, name: '绿色印象计球卡', background_color: '298c2e', font_color: 'ffffff', price: 1, total_amount: 0, valid_months: 12, maximum_vacancies: 0, ball_amount: 20000, vacancy_tag_ids: [regular_tag.id]).tap do |card|
      card.reset_use_rights_by_vacancy_tag_ids
      [{ number: 'LS001', last_name: '穆', first_name: '飞', gender: :male, phone: '13701037884' },
      { number: 'LS002', last_name: '郑', first_name: '建生', gender: :male, phone: '13910702021' },
      { number: 'LS003', last_name: '梁', first_name: '程超', gender: :male, phone: '13810066253' },
      { number: 'LS004', last_name: '郭', first_name: '加', gender: :male, phone: '13801225770' },
      { number: 'LS005', last_name: '杨', first_name: '向东', gender: :male, phone: '13701313095' },
      { number: 'LS006', last_name: '黄', first_name: '佳利', gender: :male, phone: '13701193371' },
      { number: 'LS007', last_name: '杨', first_name: '东升', gender: :male, phone: '13848287333' },
      { number: 'LS008', last_name: '李', first_name: '云峰', gender: :male, phone: '13501211191' },
      { number: 'LS009', last_name: '陈', first_name: '瑜', gender: :male, phone: '13601271666' },
      { number: 'LS010', last_name: '赵', first_name: '永松', gender: :male, phone: '13901216864' },
      { number: 'LS011', last_name: '林', first_name: '克青', gender: :male, phone: '18611628266' },
      { number: 'LS012', last_name: '谢', first_name: '贤辉', gender: :male, phone: '13911725679' },
      { number: 'LS013', last_name: '薛', first_name: '凡伟', gender: :male, phone: '18101078787' },
      { number: 'LS014', last_name: '李', first_name: '卫', gender: :male, phone: '13501180901' },
      { number: 'LS015', last_name: '贾', first_name: '浩', gender: :male, phone: '13911569865' },
      { number: 'LS016', last_name: '商', first_name: '晓军', gender: :male, phone: '18010105056' },
      { number: 'LS017', last_name: '陈', first_name: '晓波', gender: :male, phone: '13911193017' },
      { number: 'LS018', last_name: '何', first_name: '威', gender: :male, phone: '13601056901' },
      { number: 'LS019', last_name: '刘', first_name: '久亮', gender: :male, phone: '13301305619' },
      { number: 'LS020', last_name: '金', first_name: '剑', gender: :male, phone: '13701199575' },
      { number: 'LS021', last_name: '于', first_name: '洪燕', gender: :male, phone: '13911135075' },
      { number: 'LS022', last_name: '刘', first_name: '国权', gender: :male, phone: '18610518811' },
      { number: 'LS023', last_name: '韩', first_name: '迎', gender: :male, phone: '13810760278' },
      { number: 'LS024', last_name: '毕', first_name: '文合', gender: :male, phone: '13370186889' },
      { number: 'LS025', last_name: '郑', first_name: '周平', gender: :male, phone: '13911194449' },
      { number: 'LS026', last_name: '段', first_name: '奇', gender: :male, phone: '13900633600' },
      { number: 'LS027', last_name: '王', first_name: '照宣', gender: :male, phone: '18610298919' },
      { number: 'LS028', last_name: '王', first_name: '睿佳', gender: :male, phone: '13001970848' },
      { number: 'LS029', last_name: '王', first_name: '胜勇', gender: :male, phone: '13701003248' },
      { number: 'LS030', last_name: '李', first_name: '涛', gender: :male, phone: '13911616156' },
      { number: 'LS031', last_name: '崔', first_name: '斐斐', gender: :male, phone: '13031003947' },
      { number: 'LS032', last_name: '柴', first_name: '延宁', gender: :male, phone: '18600952092' },
      { number: 'LS033', last_name: '杨', first_name: '贵贤', gender: :male, phone: '13701287331' },
      { number: 'LS034', last_name: '易', first_name: '芬芬', gender: :male, phone: '18101097933' },
      { number: 'LS035', last_name: '谢', first_name: '谦', gender: :male, phone: '13581510365' },
      { number: 'LS036', last_name: '何', first_name: '贤周', gender: :male, phone: '13911500997' },
      { number: 'LS037', last_name: '王', first_name: '健', gender: :male, phone: '13436518409' },
      { number: 'LS038', last_name: '宋', first_name: '佳', gender: :male, phone: '13811531770' },
      { number: 'LS039', last_name: '孙', first_name: '志华', gender: :male, phone: '13901298882' },
      { number: 'LS040', last_name: '王', first_name: '越', gender: :male, phone: '13901393341' },
      { number: 'LS041', last_name: '迟', first_name: '春玲', gender: :male, phone: '18600261107' },
      { number: 'LS042', last_name: '蔡', first_name: '娜', gender: :male, phone: '13701131234' },
      { number: 'LS043', last_name: '施', first_name: '红梅', gender: :male, phone: '13910286716' },
      { number: 'LS044', last_name: '陈', first_name: '清堂', gender: :male, phone: '13701155067' },
      { number: 'LS045', last_name: '刘', first_name: '丹阳', gender: :male, phone: '18600763802' },
      { number: 'LS046', last_name: '马', first_name: '强', gender: :male, phone: '13693298183' },
      { number: 'LS047', last_name: '刘', first_name: '斌', gender: :male, phone: '13911115162' },
      { number: 'LS048', last_name: '齐', first_name: '连宝', gender: :male, phone: '15901198916' },
      { number: 'LS049', last_name: '林', first_name: '杰', gender: :male, phone: '13910034728' },
      { number: 'LS050', last_name: '王', first_name: '照宣', gender: :male, phone: '18610298919' }].each do |member|
        club.members.create_with_user(club, Op::CreateMember.new(phone: member[:phone], last_name: member[:last_name], first_name: member[:first_name], gender: member[:gender], number: member[:number], card_id: card.id))
      end
      User.where(phone:'13701037884').first.members.first.update!(ball_amount:7020)
      User.where(phone:'13910702021').first.members.first.update!(ball_amount:4200)
      User.where(phone:'13810066253').first.members.first.update!(ball_amount:3450)
      User.where(phone:'13801225770').first.members.first.update!(ball_amount:5880)
      User.where(phone:'13701313095').first.members.first.update!(ball_amount:2010)
      User.where(phone:'13701193371').first.members.first.update!(ball_amount:8250)
      User.where(phone:'13848287333').first.members.first.update!(ball_amount:21390)
      User.where(phone:'13501211191').first.members.first.update!(ball_amount:11100)
      User.where(phone:'13601271666').first.members.first.update!(ball_amount:1230)
      User.where(phone:'13901216864').first.members.first.update!(ball_amount:6090)
      User.where(phone:'18611628266').first.members.first.update!(ball_amount:17370)
      User.where(phone:'13911725679').first.members.first.update!(ball_amount:5640)
      User.where(phone:'18101078787').first.members.first.update!(ball_amount:9690)
      User.where(phone:'13501180901').first.members.first.update!(ball_amount:14400)
      User.where(phone:'13911569865').first.members.first.update!(ball_amount:2040)
      User.where(phone:'18010105056').first.members.first.update!(ball_amount:10590)
      User.where(phone:'13911193017').first.members.first.update!(ball_amount:660)
      User.where(phone:'13601056901').first.members.first.update!(ball_amount:12180)
      User.where(phone:'13301305619').first.members.first.update!(ball_amount:12510)
      User.where(phone:'13701199575').first.members.first.update!(ball_amount:2820)
      User.where(phone:'13911135075').first.members.first.update!(ball_amount:9510)
      User.where(phone:'18610518811').first.members.first.update!(ball_amount:7590)
      User.where(phone:'13810760278').first.members.first.update!(ball_amount:14610)
      User.where(phone:'13370186889').first.members.first.update!(ball_amount:6720)
      User.where(phone:'13911194449').first.members.first.update!(ball_amount:8280)
      User.where(phone:'13900633600').first.members.first.update!(ball_amount:9450)
      User.where(phone:'18610298919').first.members.first.update!(ball_amount:10140)
      User.where(phone:'13001970848').first.members.first.update!(ball_amount:13680)
      User.where(phone:'13701003248').first.members.first.update!(ball_amount:11550)
      User.where(phone:'13911616156').first.members.first.update!(ball_amount:7860)
      User.where(phone:'13031003947').first.members.first.update!(ball_amount:12000)
      User.where(phone:'18600952092').first.members.first.update!(ball_amount:3690)
      User.where(phone:'13701287331').first.members.first.update!(ball_amount:7110)
      User.where(phone:'18101097933').first.members.first.update!(ball_amount:7290)
      User.where(phone:'13581510365').first.members.first.update!(ball_amount:9990)
      User.where(phone:'13911500997').first.members.first.update!(ball_amount:6990)
      User.where(phone:'13436518409').first.members.first.update!(ball_amount:8430)
      User.where(phone:'13811531770').first.members.first.update!(ball_amount:3450)
      User.where(phone:'13901298882').first.members.first.update!(ball_amount:10290)
      User.where(phone:'13901393341').first.members.first.update!(ball_amount:9210)
      User.where(phone:'18600261107').first.members.first.update!(ball_amount:14640)
      User.where(phone:'13701131234').first.members.first.update!(ball_amount:6000)
      User.where(phone:'13910286716').first.members.first.update!(ball_amount:5040)
      User.where(phone:'13701155067').first.members.first.update!(ball_amount:12900)
      User.where(phone:'18600763802').first.members.first.update!(ball_amount:12780)
      User.where(phone:'13693298183').first.members.first.update!(ball_amount:9450)
      User.where(phone:'13911115162').first.members.first.update!(ball_amount:3000)
      User.where(phone:'15901198916').first.members.first.update!(ball_amount:9390)
      User.where(phone:'13910034728').first.members.first.update!(ball_amount:10500)
      User.where(phone:'18610298919').first.members.first.update!(ball_amount:1980)
    end
  end

  def fake_image_file options = {}
    if options[:allow_blank]
      rand(1..10) > 3 ? File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..200).to_s.rjust(3, '0')}.jpg")) : nil
    else
      File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..200).to_s.rjust(3, '0')}.jpg"))
    end
  end

  def fake_tabs options = {}
    user, club = options[:user], options[:club]
    entrance_date = Time.now.beginning_of_day - 1.year
    20.times do
      tab = Tab.set_up({ club_id: club.id, user_id: user.id, operator_id: club.operator_ids.sample }, club.vacancy_ids.sample(rand(1..3)).join(','))
      playing_minutes = rand(40..160).minutes
      tab.update!(entrance_time: entrance_date + rand(560..860).minutes)
      tab.playing_items.each do |playing_item|
        rand(1..4).times do
          playing_item.balls.create!(amount: 30 * rand(1..4))
        end
        playing_item.finish!
        playing_item.update!(started_at: tab.entrance_time, finished_at: tab.entrance_time + playing_minutes)
        payment_method = if user.members.map{|m| m.card.type}.include?(:by_time)
          'by_time_member'
        else
          ['credit_card', 'cash'].sample
        end
        member_id = user.members.select{|m| m.card.type_by_time?}.first.try(:id)
        playing_item.update_payment_method(charging_type: :by_time, payment_method: payment_method, member_id: member_id)
      end
      rand(0..3).times do
        provision_item = tab.provision_items.create!(provision_id: club.provisions.sample.id, quantity: rand(1..4))
        provision_item.update_payment_method(payment_method: [:credit_card, :cash].sample)
      end
      tab.reload
      tab.confirm(:by_app)
      tab.update!(departure_time: tab.entrance_time + playing_minutes)
      entrance_date += rand(1..10).days
    end
  end
end