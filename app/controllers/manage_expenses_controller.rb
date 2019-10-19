class ManageExpensesController < ApplicationController
  before_action :find_project, :authorize

  menu_item :expenses


  def view
  	#Rails.logger.warn("MEEEE :project_id: #{:project_id}")
  	#Rails.logger.warn("MEEEE params[:project_id]: #{params[:project_id]}")
  	#Rails.logger.warn("MEEEE @project: #{@project}")
  	#Rails.logger.warn("MEEEE @project.inspect: #{@project.inspect}")

  	@expenses_list = Expense.where(:project_id => @project.id).order(date: :asc)
    @expense_this_project = Expense.where(:project_id => @project.id).sum(:amount)
  end


  def form_add_expense
    # hashmap degli utenti  a cui puo' essere assegnata una spesa
    payers_users = User.active.all().map{ |c| [c.name, 'user-' + c.id.to_s] }.to_h

    # hasmap dei gruppi non builtin ai quali può essere assegnata una spesa
    payers_groups = Group.all().map{ |c| ([c.name, 'group-' + c.id.to_s] if !c.builtin? ) }.reject{ |k,v| v.nil? }.to_h

    # hasmap dei possibili assegnatari di una spesa
    @payers = payers_users.merge(payers_groups)

    @exp_entry ||= Expense.new(:project_id => @project.id)

  end

  def add
     pb_type = params[:expense][:paid_by].split('-')[0]
     if pb_type == 'user'
       pb_type = 0 # user
     elsif pb_type == 'group'
       pb_type = 1 # group
     else
       raise "Il tipo di payer specificato (#{params[:expense][:paid_by]}) non e' valido."
     end 

     pb_id = params[:expense][:paid_by].split('-')[1].to_i

     exp_entry = Expense.new(:project_id => Project.find(params[:project_id]).id, 
                             :date => params[:expense][:date], 
                             :amount => params[:expense][:amount],
                             :paid_by => pb_id,
                             :payer_type => pb_type,
                             :description => params[:expense][:description])

    if exp_entry.save
      flash[:notice] = 'Expense added.'
      redirect_to :action => 'view'
    else
      flash[:error] = 'Error adding added.'
      redirect_to :action => 'form_add_expense'
    end

    # Expense.create(:project_id => 1, :amount => 6, :date => Date.strptime("14/04/17", "%d/%m/%y"), :paid_by => 1, :description => "La mia prima descrizione!")
    #Expense.create(:project_id => 1, :amount => 12, :date => Date.today, :paid_by => 1, :description => "Autogenerata...")
    #flash[:notice] = 'Expense Created.'
    #redirect_to :action => 'view'
  end

  def remove
    exp = Expense.find(params[:expense_id]).destroy
    flash[:notice] = 'Expense deleted.'
    redirect_to :action => 'view'
  end

  def find_project
        # @project variable must be set before calling the authorize filter
        @project = Project.find(params[:project_id])
  end

end
