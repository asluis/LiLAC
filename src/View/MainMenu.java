package View;

import Controller.Controller;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;

public class MainMenu extends VBox {
    private Button login;
    private Button createAccount;
    private Controller ctrl;
    private Label title;
    private Button addFlower;

    public MainMenu(Controller controller){
        this.ctrl = controller;

        title = new Label("LiLAC");
        title.setFont(new Font("Arial", 70));

        login = new Button("Login");
        // TODO: Handle event correctly
        login.addEventHandler(MouseEvent.MOUSE_CLICKED, e -> System.out.println("Login clicked"));
        createAccount = new Button("Create Account");

        // TODO: Handle event correctly
        createAccount.addEventHandler(MouseEvent.MOUSE_CLICKED, e -> System.out.println("Signup clicked"));

        addFlower = new Button("Create flower");
        addFlower.addEventHandler(MouseEvent.MOUSE_CLICKED, e -> System.out.println("Add flower") );

        login.setPrefSize(300,150);
        createAccount.setPrefSize(300, 150);

        setSpacing(50);
        setAlignment(Pos.CENTER);
        setPrefWidth(400);
        getChildren().add(title);
        getChildren().add(login);
        getChildren().add(createAccount);
        getChildren().add(addFlower);
    }
}
