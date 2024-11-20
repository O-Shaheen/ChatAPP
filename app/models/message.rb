class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  
    belongs_to :chat
  
    validates :number, presence: true, uniqueness: { scope: :chat_id }
    validates :body, presence: true
  
    after_commit :index_document, on: [:create, :update, :destroy]
  
    def index_document
      __elasticsearch__.index_document
    end
  
    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :body, analyzer: 'english'
      end
    end
  
  end