
import javax.swing.JButton;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author menna
 */
public abstract class SearchStrategy {
    GUI gui;
    SearchStrategy(GUI g){this.gui = g;}
    abstract String generateInputQuery();
    abstract String[] generateSolution();
        
}
