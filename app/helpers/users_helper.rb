module UsersHelper
  def all_emails_used_by(user)
    user
      .audits
      .descending
      .map { |audit| audit.action == 'update' ? audit.audited_changes[:email].last : audit.audited_changes['email'] }
      .uniq
  end
end
