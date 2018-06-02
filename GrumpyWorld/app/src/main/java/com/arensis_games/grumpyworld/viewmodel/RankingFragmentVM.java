package com.arensis_games.grumpyworld.viewmodel;

import android.app.Application;
import android.arch.lifecycle.AndroidViewModel;
import android.arch.lifecycle.MutableLiveData;
import android.support.annotation.NonNull;

import com.arensis_games.grumpyworld.R;
import com.arensis_games.grumpyworld.connection.BearerAuthInterceptor;
import com.arensis_games.grumpyworld.connection.FabricacionInterface;
import com.arensis_games.grumpyworld.connection.GestoraToken;
import com.arensis_games.grumpyworld.connection.RankingInterface;
import com.arensis_games.grumpyworld.model.Equipable;
import com.arensis_games.grumpyworld.model.Ranking;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by dparrado on 15/02/18.
 */

public class RankingFragmentVM extends AndroidViewModel {
    private MutableLiveData<Ranking> ldRanking;
    private MutableLiveData<String> ldError;

    public RankingFragmentVM(@NonNull Application application) {
        super(application);
        ldRanking = new MutableLiveData<>();
        ldError = new MutableLiveData<>();
    }

    public MutableLiveData<Ranking> getLdRanking() {
        return ldRanking;
    }

    public MutableLiveData<String> getLdError() {
        return ldError;
    }


    public void obtenerRanking(){
        OkHttpClient client;
        Retrofit retrofit;
        RankingInterface rankingInterface;

        /*
            Android puede haber borrado el dato estático si necesita memoria.
            En ese caso se manda al usuario a la pantalla de inicio para que
            el sistema inicie sesión de nuevo.
        */
        if(GestoraToken.getAuthorization() != null){
            client = new OkHttpClient.Builder()
                    .addInterceptor(new BearerAuthInterceptor(GestoraToken.getAuthorization()))
                    .build();

            retrofit = new Retrofit.Builder()
                    .baseUrl(getApplication().getString(R.string.SERVER_URL))
                    .client(client)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            rankingInterface = retrofit.create(RankingInterface.class);

            rankingInterface.getRanking().enqueue(new Callback<Ranking>() {
                @Override
                public void onResponse(Call<Ranking> call, Response<Ranking> response) {
                    if(response.isSuccessful()){
                        ldRanking.postValue(response.body());
                        GestoraToken.setAuthorization(response.headers().get("Authorization"));
                    }else{
                        /*
                            Puede haber pasado una hora desde que el usuario uso la app por última
                            vez y que Android aún no haya borrado el token de memoria por lo que
                            dejaría de ser válido (401 Unauthorized)
                            En ese caso se manda al usuario a la pantalla de inicio para que
                            el sistema inicie sesión de nuevo.
                         */
                        ldError.setValue(String.valueOf(response.code()));
                    }
                }

                @Override
                public void onFailure(Call<Ranking> call, Throwable t) {
                    ldError.postValue(t.getMessage());
                }
            });
        }else{
            ldError.setValue("401");
        }
    }
}