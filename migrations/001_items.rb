Sequel.migration do
  up do
    create_table :boards do
      primary_key :rno
      String :board_id
      Time   :created_at
      unique [:board_id]
    end
    create_table :items do
      primary_key :rno
      String :board_id
      String :iid
      String :status
      Text   :annotation
      Time   :created_at
      Time   :updated_at
      unique [:board_id, :iid]
      end
  end

  down do
    drop_table(:items)
    drop_table(:boards)
  end
end
