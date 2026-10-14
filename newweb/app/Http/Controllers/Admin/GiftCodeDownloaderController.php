<?php


namespace App\Http\Controllers\Admin;


use Illuminate\Support\Facades\Storage;

class GiftCodeDownloaderController extends \Illuminate\Routing\Controller
{
    public function index($uniqid, $filename)
    {
        if (empty($uniqid)) {
            abort(404);
        }
        if (empty($filename)) {
            $filename = 'code.txt';
        }
        if (Storage::disk('giftcode')->exists($uniqid.DIRECTORY_SEPARATOR.$filename)) {
            $headers = array(
                'Content-Type: text/plain',
            );
            return Storage::disk('giftcode')->download($uniqid.DIRECTORY_SEPARATOR.$filename, $filename, $headers);
        }
        abort(404);
    }
}
