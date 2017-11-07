class Admin::StudentsController < AdminController
  load_and_authorize_resource
  inherit_resources
  respond_to :html, :json
  assign_params :id, :external_user_id, :first_name, :native_language, :expiration_date, :date_of_next_vpa, :tutoring_credits, :phone_number, :level, :can_reserve_group_sessions,
    :email, :password, :segment_id, :status
  before_filter :prepare_data, only: [:new, :show]
  has_scope :page, default: 1
  has_scope :per, default: 10

  def new
    @voxy_user = {}
  end

  def show
    voxy = VoxyService.new()
    @voxy_user = voxy.get_user(resource.external_user_id)
  end

  def update
    if params[:student][:password].blank?
      params[:student].delete :password
    end
    update!
  end

  def learn
    voxy = VoxyService.new()
    auth = voxy.get_auth_token(resource.external_user_id)
    puts auth
    if auth[:code] == "200"
      redirect_to auth[:body]['actions']['start']
    else

    end
  end

  protected

  def collection
    if params[:type] == 'expried'
      @students =  Student.where("to_date(expiration_date, 'YYYY-MM-DD') BETWEEN ? AND ?", Date.today, Date.today + 7.days).page(params[:page])
    elsif params[:q].present?
      @students = Student.where("email = ? OR external_user_id = ?", params[:q], params[:q]).order(level: :asc).page(params[:page])
    else
      @students = Student.order(level: :asc).page(params[:page])
    end
  end

  def prepare_data
    voxy = VoxyService.new()
    @language_supports = voxy.get_language_support
  end

end

