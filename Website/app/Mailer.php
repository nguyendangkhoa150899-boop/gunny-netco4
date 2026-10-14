<?php


namespace App;

use Illuminate\Support\Facades\Log;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;


class Mailer
{
    protected $mail;
    public function __construct()
    {
        $this->mail = new PHPMailer(true);
        //Server settings
        //$this->mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
        $this->mail->isSMTP();                                            //Send using SMTP
        $this->mail->Host       = env('MAIL_HOST', 'smtp.gmail.com'); //'smtp.hostinger.com';                     //Set the SMTP server to send through
        $this->mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $this->mail->Username   = env('MAIL_USERNAME', 'ad.gunnyae.com@gmail.com');                     //SMTP username
        $this->mail->Password   = env('MAIL_PASSWORD', 'mimcwjhfwcweavny');                               //SMTP password
        $this->mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
        $this->mail->Port       = 465; //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
        $this->mail->CharSet = 'UTF-8';

        //Recipients
        $this->mail->setFrom('ad.gunnyae.com@gmail.com', 'gunny92');
        //Name is optional
        //$mail->addReplyTo('info@example.com', 'Information');
        //$mail->addCC('cc@example.com');
        //$mail->addBCC('bcc@example.com');

        //Attachments
        //$mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
        //$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name

        //Content


		// FIX AUTHENTICATE
		$this->mail->SMTPOptions = array(
		'ssl' => array(
			'verify_peer' => false,
			'verify_peer_name' => false,
			'allow_self_signed' => true
			)
		);
    }

    public function sendForgotPasswordMail($to, $url)
    {
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Khôi phục mật khẩu - gunny92';
            $this->mail->Body = '<p>Truy cập vào đường dẫn bên dưới để khôi phục lại mật khẩu:</p><a href="'.$url.'">Khôi phục mật khẩu - gunny92</a>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function sendTwoFactorAuthenticateCode($to, $code)
    {
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Mã xác thực 2 lớp - gunny92';
            $this->mail->Body = '<p>Mã xác thực 2 lớp bạn của bạn là:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function sendVerifyEmailLink($to, $url)
    {
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Xác thực địa chỉ email - gunny92';
            $this->mail->Body = '<p>Truy cập vào đường dẫn bên dưới để xác thực địa chỉ Email (Lưu ý phải đăng nhập vào hệ thống):</p><a href="'.$url.'">Nhấn vào đây để xác thực email - gunny92</a>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function verifyChangeEmailVerifiedCode($to, $code)
    {
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Mã xác thực đổi Email - gunny92';
            $this->mail->Body = '<p>Đây là mã xác thực để thay đổi địa chỉ email:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

}
