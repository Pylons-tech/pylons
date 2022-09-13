
type QueryListCookbooksByCreatorResponse struct {
	Cookbooks []Cookbook `protobuf:"bytes,1,rep,name=cookbooks,proto3" json:"cookbooks"`
	// pagination defines the pagination in the response.
	Pagination *query.PageResponse `protobuf:"bytes,3,opt,name=pagination,proto3" json:"pagination,omitempty"`
}

type QueryListTradesByCreatorResponse struct {
	Trades []Trade `protobuf:"bytes,1,rep,name=trades,proto3" json:"trades"`
	// pagination defines the pagination in the response.
	Pagination *query.PageResponse `protobuf:"bytes,2,opt,name=pagination,proto3" json:"pagination,omitempty"`
}