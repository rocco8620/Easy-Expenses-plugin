require 'redmine'

require_dependency 'expenses_hook_listener'

Redmine::Plugin.register :expenses do
  name 'Easy Expenses plugin'
  author 'Rocco Mancin'
  description 'Plugin per tracciare le spese sostenute relative ad un progetto.'
  version '0.0.1'

  # I permessi si riferiscono ad un controller.
  permission :list_global_expenses, :global_view => :view

  menu :project_menu, :expenses, { :controller => 'manage_expenses', :action => 'view' }, :caption => 'Expenses', 
                      :after => :activity, 
                      :param => :project_id
  menu :application_menu, :global_view, { :controller => 'global_view', :action => 'view' }, :caption => 'Expenses', 
                          :if => Proc.new { User.current.allowed_to?(:list_global_expenses, nil, :global => true) }, 
                          :after => :activity

  project_module :expenses do
    permission :list_expenses, :manage_expenses => :view
    permission :add_expense, :manage_expenses => [:add, :form_add_expense]
    permission :remove_expense, :manage_expenses => :remove
  end

end


