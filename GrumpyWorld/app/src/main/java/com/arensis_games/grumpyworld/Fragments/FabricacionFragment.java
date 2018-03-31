package com.arensis_games.grumpyworld.Fragments;


import android.arch.lifecycle.Observer;
import android.arch.lifecycle.ViewModelProviders;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.arensis_games.grumpyworld.Adapters.AdaptadorFabricacion;
import com.arensis_games.grumpyworld.Adapters.AdaptadorMapa;
import com.arensis_games.grumpyworld.Gestoras.GestoraGUI;
import com.arensis_games.grumpyworld.Models.Equipable;
import com.arensis_games.grumpyworld.Models.Zona;
import com.arensis_games.grumpyworld.R;
import com.arensis_games.grumpyworld.ViewModels.FabricacionFragmentVM;
import com.arensis_games.grumpyworld.ViewModels.MainActivityVM;
import com.arensis_games.grumpyworld.ViewModels.MapaFragmentVM;

public class FabricacionFragment extends Fragment implements AdapterView.OnItemClickListener{

    private FabricacionFragmentVM vm;
    private Observer<Equipable[]> equipablesObserver;
    private Observer<Integer> errorObserver;
    private ListView lista;
    private TextView texto;
    private FabricacionFragment thisFragment = this;
    private GestoraGUI gesGUI = new GestoraGUI();
    private ProgressBar progress;

    public FabricacionFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_mapa, container, false);

        lista = view.findViewById(R.id.lista);
        texto = view.findViewById(R.id.texto);
        progress = view.findViewById(R.id.progress);

        vm = ViewModelProviders.of(this).get(FabricacionFragmentVM.class);

        equipablesObserver = new Observer<Equipable[]>() {
            @Override
            public void onChanged(@Nullable Equipable[] equipables) {
                if(equipables != null){
                    progress.setVisibility(View.GONE);
                    lista.setAdapter(new AdaptadorFabricacion<Equipable>(getContext(),
                            R.layout.fila_mapa, R.id.tvNombre, equipables));
                    lista.setOnItemClickListener(thisFragment);
                }
            }
        };
        vm.getLdEquipables().observe(this, equipablesObserver);

        errorObserver = new Observer<Integer>() {
            @Override
            public void onChanged(@Nullable Integer error) {
                if(error != null){
                    ViewModelProviders.of(getActivity()).get(MainActivityVM.class).emitirErrorGlobal(error);
                }
            }
        };
        vm.getLdError().observe(this, errorObserver);


        vm.obtenerEquipablesDisponibles();

        return view;
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        AdaptadorFabricacion.ViewHolder holder = (AdaptadorFabricacion.ViewHolder) view.getTag();
        Fragment fragment = new FabricacionDetalleFragment();
        Bundle args = new Bundle();
        args.putInt("id", holder.getEquipable().getId());
        fragment.setArguments(args);
        ViewModelProviders.of(getActivity()).get(MainActivityVM.class).cambiarFragment(fragment);
    }
}