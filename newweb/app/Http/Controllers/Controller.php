<?php

namespace App\Http\Controllers;

use App\Member;
use App\Models\Setting;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Symfony\Component\HttpFoundation\Session\Session;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    private $session;

    private function getSessionObject()
    {
        if (empty($this->session)) {
            $this->session = new Session();
        }
        return $this->session;
    }
    protected function getSession($key, $default = '')
    {
        return $this->getSessionObject()->get($key, $default);
    }

    protected function setSession($key, $value)
    {
        $this->getSessionObject()->set($key, $value);
    }

    protected function unsetSession($key)
    {
        $this->getSessionObject()->remove($key);
    }

    protected function success($message = '', $data = [], $status = true)
    {
        $returnval = ['success' => $status, 'message' => $message];
        if (!empty($data)) {
            $returnval['data'] = $data;
        }
        echo json_encode($returnval);
        exit;
    }

    protected function error($message = '', $data = [], $status = false)
    {
        $returnval = ['success' => $status, 'message' => $message];
        if (!empty($data)) {
            $returnval['data'] = $data;
        }
        echo json_encode($returnval);
        exit;
    }

    protected function getCurrentMember()
    {
        $m = new Member();
        return $m->current();
    }
}
