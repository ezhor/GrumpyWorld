<?php
/**
 * Created by PhpStorm.
 * User: ezhor
 * Date: 23/01/2018
 * Time: 20:34
 */

require_once "jwt/SignatureInvalidException.php";
require_once "jwt/ExpiredException.php";
require_once "jwt/BeforeValidException.php";
require_once "jwt/JWT.php";
require_once "Authentication.php";

use Firebase\JWT\JWT as JWT;


class GestoraAutenticacion
{
    private $key;

    /**
     * GestoraAutenticacion constructor.
     */
    public function __construct()
    {
        $config = parse_ini_file('../../config/config.ini');
        $this->key = $config['key'];
    }


    //Autenticacion pasada por referencia
    public function comprobarAutenticacion(Authentication &$autenticacion){
        $resultado = false;
        $token = $autenticacion->getToken();
        if(isset($token)){
            try{
                $jwtDecodificado = JWT::decode($token, $this->key, array('HS256'));
                $data = $jwtDecodificado->data;
                $id = $data->id;
                $autenticacion->setId($id);
                $resultado = true;
            }catch (Exception $e){

            }
        }
        else{
            $usuario = $autenticacion->getUsuario();
            $contrasena = $autenticacion->getContrasena();

            if(isset($usuario) && isset($contrasena)){
                $db = DatabaseModel::getInstance();
                $db_connection = $db->getConnection();

                $query = "SELECT ID, Contrasena FROM Usuarios WHERE Usuario = ?";
                $prep_query = $db_connection->prepare($query);
                $prep_query->bind_param('s', $usuario);
                $prep_query->bind_result($id, $contrasena_hash);
                $prep_query->execute();
                $prep_query->fetch();
                if(password_verify($contrasena, $contrasena_hash)){
                    $autenticacion->setId($id);
                    $resultado = true;
                }

            }
        }
        return $resultado;
    }

    public function getAutenticacion(){
        $id = null;
        $token = null;
        $usuario = null;
        $contrasena = null;

        if(isset(apache_request_headers()['Authorization'])){
            $cabeceraAuhorization = trim(apache_request_headers()['Authorization']);

            if (!empty($cabeceraAuhorization)) {
                if (preg_match('/Bearer\s(\S+)/', $cabeceraAuhorization, $matches)) {
                    $token = $matches[1];
                }else{
                    if(isset($_SERVER['PHP_AUTH_USER']) || isset($_SERVER['PHP_AUTH_PW'])){
                        $usuario = $_SERVER['PHP_AUTH_USER'];
                        $contrasena = $_SERVER['PHP_AUTH_PW'];
                    }
                }
            }
        }
        return new Authentication($id, $usuario, $contrasena, $token);
    }

    public function getTokenNuevo($id){
        $time = time();

        $token = array(
            'iat' => $time, // Tiempo que inició el token
            'exp' => $time + (60*60), // Tiempo que expirará el token (+1 hora)
            'data' => [ // información del usuario
                'id' => $id
            ]
        );
        $jwt = JWT::encode($token, $this->key);

        return $jwt;
    }
}