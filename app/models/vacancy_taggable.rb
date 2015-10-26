class VacancyTaggable < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :tag, class_name: 'VacancyTag'
end