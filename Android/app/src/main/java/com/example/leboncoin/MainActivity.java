package com.example.leboncoin;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    ArrayList<AdModel> ListModel = new ArrayList();

    AdModel M1 = new AdModel("Model1", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M2 = new AdModel("Model2", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M3 = new AdModel("Model3", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M4 = new AdModel("Model4", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M5 = new AdModel("Model5", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M6 = new AdModel("Model6", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M7 = new AdModel("Model7", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M8 = new AdModel("Model8", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M9 = new AdModel("Model9", "Courcelles-Chaussy, 57530", R.drawable.image0);
    AdModel M10 = new AdModel("Model10", "Courcelles-Chaussy, 57530", R.drawable.image0);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Intent i = getIntent();
        AdModel model = (AdModel) i.getSerializableExtra("add_model");
        if(model != null){
            ListModel.add(model);
        }

        ListModel.add(M1);
        ListModel.add(M2);
        ListModel.add(M3);
        ListModel.add(M4);
        ListModel.add(M5);
        ListModel.add(M6);
        ListModel.add(M7);
        ListModel.add(M8);
        ListModel.add(M9);
        ListModel.add(M10);

        RecyclerViewAdAdapter adapter = new RecyclerViewAdAdapter(this, ListModel);

        GridLayoutManager GridLayout = new GridLayoutManager(this,2);

        RecyclerView recyclerview = (RecyclerView) findViewById(R.id.RecyclerView);
        recyclerview.setLayoutManager(GridLayout);
        recyclerview.setAdapter(adapter);

        Button button_add = (Button) findViewById(R.id.button_add);
        button_add.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Intent goAdAddActivity = new Intent(MainActivity.this, AdAddActivity.class);
                startActivity(goAdAddActivity);
            }
        });
    }
}