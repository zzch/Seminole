class Lesson < ActiveRecord::Base
  include UUID
  attr_accessor :started_at_date
  attr_accessor :started_at_time
  attr_accessor :finished_at_date
  attr_accessor :finished_at_time
  belongs_to :course
  has_many :curriculums
  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :maximum_students, presence: true, numericality: { only_integer: true }

  def reserve_open user
    ActiveRecord::Base.transaction do
      self.lock!
      raise PermissionDenied.new if Student.where(course_id: self.course.id, user_id: user.id).first.blank?
      raise FullLesson.new if self.curriculums.count >= self.maximum_students
      raise DuplicatedReservation.new if self.curriculums.map(&:user_id).include?(user.id)
      self.curriculums.create!(user: user)
    end
  end

  class << self
    def reserve_private options = {}
      ActiveRecord::Base.transaction do
        options[:course].lock!
        started_at = Time.at(options[:reserved_at])
        raise AlreadyReserved.new unless options[:course].lessons.where('(started_at >= ? AND started_at < ?) OR (finished_at > ? AND finished_at <= ?)', started_at, started_at + 1.hour, started_at, started_at + 1.hour).blank?
        options[:course].lessons.create!(started_at: started_at, finished_at: started_at + 1.hour, maximum_students: options[:course].maximum_students)
      end
    end
  end
end