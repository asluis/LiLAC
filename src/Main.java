import Controller.Controller;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage){

        primaryStage.setTitle("LiLAC");
        primaryStage.setHeight(1000);
        primaryStage.setWidth(1000);
        Controller ctrl = new Controller(primaryStage);
        ctrl.start();
    }

    public static void main(String[] args){
        launch(args);
    }
}
