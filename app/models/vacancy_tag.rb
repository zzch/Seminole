class VacancyTag < ActiveRecord::Base
  belongs_to :club
  has_many :vacancy_taggables, foreign_key: 'tag_id'
  has_many :use_rights
end