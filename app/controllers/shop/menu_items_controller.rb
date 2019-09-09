class Shop::MenuItemsController < ApplicationController
    before_action :authenticate_shop!
    def index
        @item_group = ItemGroup.find(params[:item_group_id])
        # 直打ち対策
        if @item_group.menu.shop_id == current_shop.id
            @menu_items = MenuItem.where(item_group_id: @item_group.id)
        else
            redirect_to top_shop_mypages_path,:alert=>'アクセス権限がありません。'
        end
    end

    def create
        @item_group = ItemGroup.find(params[:item_group_id])
        # 直打ち対策
        if @item_group.menu.shop_id == current_shop.id
            @menu_item = MenuItem.new(menu_item_params)
            @menu_item.item_group_id = @item_group.id
            if @menu_item.save
                redirect_to shop_item_group_menu_items_path(@item_group),:notice=>'追加しました。'
            else
                @menu_items = MenuItem.where(item_group_id: params[:item_group_id])
                render :index
            end
        else
            redirect_to top_shop_mypages_path,:alert=>'アクセス権限がありません。'
        end
    end

    def show
        @item_group = ItemGroup.find(params[:id])
        if @item_group.menu.shop_id == current_shop
            redirect_to top_shop_mypage_path,:notice=>'アクセス権限がありません。'
        end
    end
    
    def edit
        @item_group = ItemGroup.find(params[:id])
        if @item_group.menu.shop_id == current_shop
            redirect_to top_shop_mypage_path,:notice=>'アクセス権限がありません。'
        end
    end
    
    # 並べ替え用
    def move_higher
        menu_item = MenuItem.find(params[:id])
        menu_item.move_higher
        # jsならrender・htmlならredirect
        respond_to do |format|
            format.js do
                @menu_items = MenuItem.where(item_group_id: menu_item.item_group_id)
                render
            end
            format.html {redirect_to shop_menu_items_path(menu_item)}
        end
    end

    def move_lower
        menu_item = MenuItem.find(params[:id])
        menu_item.move_lower
        # jsならrender・htmlならredirect
        respond_to do |format|
            format.js do
                @menu_items = MenuItem.where(item_group_id: menu_item.item_group_id)
                render
            end
            format.html {redirect_to shop_menu_items_path(menu_item)}
        end
    end

    private
    def menu_item_params
        params.require(:menu_item).permit(:price,:item_name,:item_text,:item_image)
    end
end
