<?php

namespace App;

use Symfony\Component\HttpFoundation\Session\Session;

class Member extends \App\Models\Member
{
    private $session;

    private function getSessionObject()
    {
        if (empty($this->session)) {
            $this->session = new Session();
        }
        return $this->session;
    }

    public function login()
    {
        $this->getSessionObject()->set('user_id', $this->UserID);
    }

    public function logout()
    {
        $this->getSessionObject()->remove('user_id');
    }

    public function getMemberId()
    {
        return $this->getSessionObject()->get('user_id');
    }

    public function isLoggedIn()
    {
        return !empty($this->getMemberId());
    }

    public function current()
    {
        $member = $this->find($this->getMemberId());
        return $member;
    }
}
