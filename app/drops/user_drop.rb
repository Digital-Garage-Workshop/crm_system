class UserDrop < BaseDrop
  def name
    @obj.try(:name).try(:split).try(:map, &:capitalize).try(:join, ' ')
  end

  def available_name
    @obj.try(:available_name)
  end

<<<<<<< HEAD
  def first_name
    @obj.try(:name).try(:split).try(:first).try(:capitalize) if @obj.try(:name).try(:split).try(:size) > 1
  end

  def last_name
    @obj.try(:name).try(:split).try(:last).try(:capitalize) if @obj.try(:name).try(:split).try(:size) > 1
=======
  def email
    @obj.try(:email)
  end

  def first_name
    @obj.try(:name).try(:split).try(:first).try(:capitalize) if @obj.try(:name).try(:split).try(:size).to_i > 1
  end

  def last_name
    @obj.try(:name).try(:split).try(:last).try(:capitalize) if @obj.try(:name).try(:split).try(:size).to_i > 1
>>>>>>> upstream/develop
  end
end
