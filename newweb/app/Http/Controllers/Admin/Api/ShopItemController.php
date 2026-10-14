<?php


namespace App\Http\Controllers\Admin\Api;


use App\Models\Shop;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\ShopGoods;

class ShopItemController extends Controller
{
    public function index(Request $request)
    {
        $search_term = $request->input('q');
        $page = $request->input('page');

        if ($search_term)
        {
            $collection = Shop::whereHas('Item', function ($q) use ($search_term) {
                $q->where('name', 'LIKE', '%' . $search_term . '%');
            })->paginate(10);
        }
        else
        {
            $collection = Shop::with('Item')->paginate(10);
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
        return Shop::with('Item')->find($id);
    }
}
