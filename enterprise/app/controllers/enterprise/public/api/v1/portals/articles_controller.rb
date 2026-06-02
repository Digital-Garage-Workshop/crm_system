module Enterprise::Public::Api::V1::Portals::ArticlesController
  private

  def search_articles
    if @portal.account.feature_enabled?('help_center_embedding_search')
<<<<<<< HEAD
      @articles = @articles.vector_search(list_params) if list_params[:query].present?
=======
      @articles = @articles.vector_search(list_params.merge(account_id: @portal.account_id)) if list_params[:query].present?
>>>>>>> upstream/develop
    else
      super
    end
  end
end
