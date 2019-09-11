class Shop::ItemGroupsController < ApplicationController
    before_action :authenticate_shop!
    def create
        item_group = ItemGroup.new(item_group_params)
        item_group.menu_id = params[:menu_id]
        correct_shop(item_group.menu) and return
        if item_group.save
            redirect_to shop_menu_path(item_group.menu),:notice =>'アイテムグループを作成しました。'
        else
            redirect_to shop_menu_path(params[:menu_id]),:alert=>'登録に失敗しました。'
        end
    end
    def destroy
        item_group = ItemGroup.find(params[:id])
        correct_shop(item_group.menu) and return
        item_group.destroy
        redirect_to shop_menu_path(item_group.menu),:notice=>'アイテムグループを削除しました。'
    end

    # 並べ替え用
    def move_higher
        item_group = ItemGroup.find(params[:id])
        # sessionチェック
        correct_shop(item_group.menu) and return
        # positionカラム更新(gem:acts_as_list)
        item_group.move_higher
        @menu = item_group.menu
        # htmlならリダイレクト、jsなら処理用のデータを渡す
        respond_to do |format|
            format.js
            format.html {redirect_to shop_menu_path(@menu)}
        end
    end

    # 並べ替え用
    def move_lower
        item_group = ItemGroup.find(params[:id])
        correct_shop(item_group.menu) and return
        item_group.move_lower
        @menu = item_group.menu
        respond_to do |format|
            format.js
            format.html {redirect_to shop_menu_path(@menu)}
        end
    end

    private
    def item_group_params
        params.require(:item_group).permit(:category_id,:group_image)
    end
end
