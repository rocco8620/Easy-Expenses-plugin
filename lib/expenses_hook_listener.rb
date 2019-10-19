class ExpensesHookListener < Redmine::Hook::ViewListener


  def view_projects_show_right(context = {})
    

    expense_this_project = Expense.where(:project_id => context[:project].id).sum(:amount)

    subprojects = context[:project].children.to_a
    if subprojects.any?

      project_and_subprojects_ids = get_ids_of_all_subprojects(context[:project])

      expense_sub_projects = Expense.where(:project_id => project_and_subprojects_ids).sum(:amount)
    else
      expense_sub_projects = 0
    end

    context[:controller].send(:render_to_string, {
        :partial => "boxes/project_expenses_box",
        :locals => { expense_this_project:  sprintf("%01.2f €", expense_this_project), 
                     expense_sub_projects:  sprintf("%01.2f €", expense_sub_projects) }
      })

    # format_time

  end

def get_ids_of_all_subprojects(starting_project)
  subprojects = starting_project.children.to_a

  if subprojects.any?
    return subprojects.map { |s| get_ids_of_all_subprojects(s) }.flatten + [starting_project.id]
  else
    return starting_project.id
  end
end

end
