Sequel.migration do
  up do
    create_table :items do
      primary_key :rno
      String      :iid
      String      :status
      Text        :annotation
      Time        :created_at
      Time        :updated_at
    end
  end

  down do
    drop_table(:items)
  end
end
