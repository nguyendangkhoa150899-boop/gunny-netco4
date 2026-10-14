<?php


namespace App\Http\Controllers\Admin\Api;


use App\Http\Requests\CreateGiftCodeRequest;
use App\Models\Active;
use App\Models\ActiveNumber;
use App\Models\Player;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class CreateGiftCodeController extends Controller
{
    public function index(CreateGiftCodeRequest $request)
    {
        $id = $request->get('id');
        $number = $request->get('number');
        $active = Active::findOrFail($id);
        if (!empty($active->CanGetCode) || $active->Type != 1) {
            echo json_encode(['success' => false, 'message' => 'Active này không cần tạo code!']);
            return;
        }
        $prefix = $active->CodePrefix;
        $codeLength = env('GIFTCODE_LENGTH', 30);
        if (!empty($prefix)) {
            $codeLength -= strlen($prefix);
        }
        $temp_id = uniqid();
        $filename = 'code'.($prefix??'').'.txt';
        $giftcodeFilePath = $temp_id.DIRECTORY_SEPARATOR.$filename;
        DB::connection('sqlsrv_tank41')->beginTransaction();
        for ($i = 0; $i < $number; $i++) {
            $code = ($prefix??'').createGiftcode('', $codeLength);
            $activeNumber = new ActiveNumber();
            $activeNumber->AwardID = $code;
            $activeNumber->ActiveID = $id;
            $activeNumber->PullDown = 0;
            $activeNumber->GetDate = date('Y-m-d H:i:s');
            $activeNumber->UserID = 0;
            $activeNumber->Mark = 0;
            if ($activeNumber->save()) {
                Storage::disk('giftcode')->append($giftcodeFilePath, $code);
            } else {
                DB::connection('sqlsrv_tank41')->rollBack();
                echo json_encode(['success' => false, 'message' => 'Có lỗi xảy ra, vui lòng liên hệ tác giả để được trợ giúp!']);
                return;
            }
        }
        DB::connection('sqlsrv_tank41')->commit();
        echo json_encode(['success' => true, 'data' => ['id' => $temp_id, 'file' => $filename]]);
        return;
    }
}
