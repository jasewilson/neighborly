class Admin::ProjectsController < Admin::BaseController
  menu I18n.t("admin.projects.index.menu") => Rails.application.routes.url_helpers.admin_projects_path

  has_scope :by_id, :pg_search, :user_name_contains, :with_state
  has_scope :between_created_at, using: [ :start_at, :ends_at ], allow_blank: true
  has_scope :order_table, default: 'created_at'

  before_filter do
    @total_projects = Project.count
  end

  [:approve, :reject, :push_to_draft, :push_to_soon].each do |name|
    define_method name do
      @project = Project.find params[:id]
      @project.send("#{name.to_s}!")
      redirect_to :back
    end
  end

  def populate
    unless params[:user][:id].present?
      password = Devise.friendly_token

      @user = User.new(params[:user])
      @user.email = "#{Devise.friendly_token}@populate.user"
      @user.password = password
      @user.password_confirmation = password
      @user.profile_type = 'personal'
    else
      @user = User.find(params[:user][:id])
    end

    @backer = Backer.new(params[:backer])
    @backer.payment_method = 'PrePopulate'
    @backer.state = 'confirmed'
    @backer.project = resource
    @backer.user = @user

    if @user.valid? and @backer.valid?
      @user.save!
      @backer.save!
      flash[:notice] = 'Success!'
      redirect_to populate_backer_admin_project_path(resource)
    else
      flash[:alert] = ""
      flash[:alert] += @user.errors.full_messages.to_sentence unless @user.valid?
      flash[:alert] += @backer.errors.full_messages.to_sentence unless @backer.valid?
      render :populate_backer
    end
  end

  def destroy
    @project = Project.find params[:id]
    if @project.can_push_to_trash?
      @project.push_to_trash!
    end

    redirect_to admin_projects_path
  end

  def collection
    @projects = apply_scopes(end_of_association_chain).without_state('deleted').page(params[:page])
  end
end
