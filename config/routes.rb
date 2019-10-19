# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get  'project/:project_id/expenses', :to => 'manage_expenses#view'
get  'project/:project_id/expenses/add', :to => 'manage_expenses#form_add_expense'
post 'project/:project_id/expenses/add', :to => 'manage_expenses#add'
get  'project/:project_id/expenses/remove/:expense_id', :to => 'manage_expenses#remove'
get  'expenses', :to => 'global_view#view'





# <%= link_to('Add expense', { :action => 'form_add_expense', :project_id => @project }, :class => 'icon icon-add', :method => :get) if User.current.allowed_to?(:add_expense, @project) %>