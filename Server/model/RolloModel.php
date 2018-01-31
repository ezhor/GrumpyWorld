<?php

/**
 * Created by PhpStorm.
 * User: dparrado
 * Date: 31/01/18
 * Time: 8:42
 */
class RolloModel implements JsonSerializable
{
    private $nombre;
    private $sombrero;
    private $arma;
    private $zona;

    /**
     * RolloModel constructor.
     * @param $nombre
     * @param $sombrero
     * @param $arma
     * @param $zona
     */
    public function __construct($nombre, $sombrero, $arma, $zona)
    {
        $this->nombre = $nombre;
        $this->sombrero = $sombrero;
        $this->arma = $arma;
        $this->zona = $zona;
    }

    /**
     * @return mixed
     */
    public function getNombre()
    {
        return $this->nombre;
    }

    /**
     * @param mixed $nombre
     */
    public function setNombre($nombre)
    {
        $this->nombre = $nombre;
    }

    /**
     * @return mixed
     */
    public function getSombrero()
    {
        return $this->sombrero;
    }

    /**
     * @param mixed $sombrero
     */
    public function setSombrero($sombrero)
    {
        $this->sombrero = $sombrero;
    }

    /**
     * @return mixed
     */
    public function getArma()
    {
        return $this->arma;
    }

    /**
     * @param mixed $arma
     */
    public function setArma($arma)
    {
        $this->arma = $arma;
    }

    /**
     * @return mixed
     */
    public function getZona()
    {
        return $this->zona;
    }

    /**
     * @param mixed $zona
     */
    public function setZona($zona)
    {
        $this->zona = $zona;
    }

    /**
     * Specify data which should be serialized to JSON
     * @link http://php.net/manual/en/jsonserializable.jsonserialize.php
     * @return mixed data which can be serialized by <b>json_encode</b>,
     * which is a value of any type other than a resource.
     * @since 5.4.0
     */
    function jsonSerialize()
    {
        return array(
            'nombre' => $this->nombre,
            'sombrero' => $this->sombrero,
            'arma' => $this->arma,
            'zona' => $this->zona
        );
    }
}