class GlobalViewController < ApplicationController

  before_action :check_perms

  menu_item :global_view

  def view
    @top_level_projects = Project.all().order(name: :asc).to_a.map { |p|
      [p, 
       Expense.where(:project_id => get_ids_of_all_subprojects(p)).sum(:amount)
      ] if p.parent == nil
    }.reject{ |v| v.nil? }

    @expense_global = Expense.sum(:amount)
  end

  def get_ids_of_all_subprojects(starting_project)
    subprojects = starting_project.children.to_a

    if subprojects.any?
      return subprojects.map { |s| get_ids_of_all_subprojects(s) }.flatten + [starting_project.id]
    else
      return starting_project.id
    end
  end

  def check_perms
    return render_403 unless User.current.allowed_to?(:list_global_expenses, nil, :global => true)
  end

end
