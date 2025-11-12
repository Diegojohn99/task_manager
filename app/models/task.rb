class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

   enum :status, { pending: 0, in_progress: 1, completed: 2 }
   enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :due_date, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  # Scopes para consultas comunes
  scope :overdue, -> { where('due_date < ? AND status != ?', Time.current, 2) }
  scope :due_today, -> { where(due_date: Time.current.all_day) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :search, ->(q) do
    next all if q.blank?
    pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
    where('title ILIKE ? OR description ILIKE ?', pattern, pattern)
  end

  # Método de instancia
  def overdue?
    due_date < Time.current && !completed?
  end
end