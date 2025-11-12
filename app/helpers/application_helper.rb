module ApplicationHelper
  def task_status_badge(status)
    case status
    when 'pending' then 'warning'
    when 'in_progress' then 'info'
    when 'completed' then 'success'
    else 'secondary'
    end
  end
end
