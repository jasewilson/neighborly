class Reports::BackerReportsForProjectOwnersController < Reports::BaseController
  before_filter :check_if_project_belongs_to_user

  def end_of_association_chain
    conditions = { project_id: params[:project_id] }

    conditions.merge!(reward_id: params[:reward_id]) if params[:reward_id].present?

    super.
      select(%Q{
        user_name as "#{I18n.t('backer_report_to_project_owner.user_name')}",
        back_value as "#{I18n.t('backer_report_to_project_owner.value')}",
        reward_minimum_value as "#{I18n.t('backer_report_to_project_owner.minimum_value')}",
        reward_description as "#{I18n.t('backer_report_to_project_owner.reward_description')}",
        created_at as "#{I18n.t('backer_report_to_project_owner.created_at')}",
        confirmed_at as "#{I18n.t('backer_report_to_project_owner.confirmed_at')}",
        service_fee as "#{I18n.t('backer_report_to_project_owner.service_fee')}",
        user_email as "#{I18n.t('backer_report_to_project_owner.user_email')}",
        payment_method as "#{I18n.t('backer_report_to_project_owner.payment_method')}",
        street as "#{I18n.t('backer_report_to_project_owner.address_street')}",
        neighbourhood as "#{I18n.t('backer_report_to_project_owner.address_neighbourhood')}",
        city as "#{I18n.t('backer_report_to_project_owner.address_city')}",
        state as "#{I18n.t('backer_report_to_project_owner.address_state')}",
        zip_code as "#{I18n.t('backer_report_to_project_owner.address_zip_code')}",
        CASE WHEN anonymous='t' THEN '#{I18n.t('yes')}'
            WHEN anonymous='f' THEN '#{I18n.t('no')}'
        END as "#{I18n.t('backer_report_to_project_owner.anonymous')}",
        short_note as "#{I18n.t('backer_report_to_project_owner.short_note')}"
      }).
      where(conditions)
  end

  def check_if_project_belongs_to_user
    redirect_to root_path unless can? :update, Project.find(params[:project_id])
  end
end
