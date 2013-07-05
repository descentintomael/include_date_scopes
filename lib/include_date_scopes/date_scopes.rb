module DateScopes
  def include_date_scopes
    include_date_scopes_for :created_at
  end

  def include_date_scopes_for(column, prepend_name = false)
    return unless self.table_exists?
    if self.columns_hash[column.to_s].type == :datetime
      define_timestamp_scopes_for column, prepend_name
    elsif self.columns_hash[column.to_s].type == :date
      define_date_scopes_for column, prepend_name
    else
      raise ArgumentError, "Can ony include datescopes for date or datetime columns"
    end
  end
end