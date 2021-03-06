<?php


class EnemigoModel implements JsonSerializable
{
    private $nombre;
    private $fuerza;
    private $constitucion;
    private $destreza;
    private $zona;
    /**
     * Model constructor.
     * @param $nombre
     * @param $fuerza
     * @param $constitucion
     * @param $destreza
     * @param $zona
     */
    public function __construct($nombre, $fuerza, $constitucion, $destreza, $zona)
    {
        $this->nombre = $nombre;
        $this->fuerza = $fuerza;
        $this->constitucion = $constitucion;
        $this->destreza = $destreza;
        $this->zona = $zona;
    }

    /**
     * Specify data which should be serialized to JSON
     * @link http://php.net/manual/en/jsonserializable.jsonserialize.php
     * @return mixed data which can be serialized by <b>json_encode</b>,
     * which is a value of any type other than a resource.
     * @since 5.4.0
     */

    //Needed if the properties of the class are private.
    //Otherwise json_encode will encode blank objects
    function jsonSerialize()
    {
        return array(
            'nombre' => $this->nombre,
            'fuerza' => $this->fuerza,
            'constitucion' => $this->constitucion,
            'destreza' => $this->destreza,
            'zona' => $this->zona
        );
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
    public function getFuerza()
    {
        return $this->fuerza;
    }

    /**
     * @param mixed $fuerza
     */
    public function setFuerza($fuerza)
    {
        $this->fuerza = $fuerza;
    }

    /**
     * @return mixed
     */
    public function getConstitucion()
    {
        return $this->constitucion;
    }

    /**
     * @param mixed $constitucion
     */
    public function setConstitucion($constitucion)
    {
        $this->constitucion = $constitucion;
    }

    /**
     * @return mixed
     */
    public function getDestreza()
    {
        return $this->destreza;
    }

    /**
     * @param mixed $destreza
     */
    public function setDestreza($destreza)
    {
        $this->destreza = $destreza;
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
}