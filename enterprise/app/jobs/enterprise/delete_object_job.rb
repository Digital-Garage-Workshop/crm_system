module Enterprise::DeleteObjectJob
<<<<<<< HEAD
=======
  private

  def heavy_associations
    super.merge(
      SlaPolicy => %i[applied_slas]
    ).freeze
  end

>>>>>>> upstream/develop
  def process_post_deletion_tasks(object, user, ip)
    create_audit_entry(object, user, ip)
  end

  def create_audit_entry(object, user, ip)
<<<<<<< HEAD
    return unless ['Inbox'].include?(object.class.to_s) && user.present?
=======
    return unless %w[Inbox Conversation SlaPolicy].include?(object.class.to_s) && user.present?
>>>>>>> upstream/develop

    Enterprise::AuditLog.create(
      auditable: object,
      audited_changes: object.attributes,
      action: 'destroy',
      user: user,
      associated: object.account,
      remote_address: ip
    )
  end
end
