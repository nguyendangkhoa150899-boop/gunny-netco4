<?php


namespace App\Http\Controllers\Admin\Api;


use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\ShopGoods;

class ShopGoodsController extends Controller
{
    public function index(Request $request)
    {
        $search_term = $request->input('q');
        $page = $request->input('page');

        if ($search_term)
        {
            $collection = ShopGoods::where('name', 'LIKE', '%'.$search_term.'%')->paginate(10);
        }
        else
        {
            $collection = ShopGoods::paginate(10);
        }
        foreach ($collection as $item)
        {
            $item->apiDisplay = $item->apiSelectionDisplay();
            $item->apiDisplayImage = $item->ResourceImageColumn();
        }

        return $collection;
    }

    public function show($id)
    {
        return ShopGoods::find($id);
    }
}
