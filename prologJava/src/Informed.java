
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.swing.JButton;
import javax.swing.JLabel;
import org.jpl7.Query;
import org.jpl7.Term;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author menna
 */
public class Informed extends SearchStrategy{

    public Informed(GUI g) {
        super(g);
    }

    @Override
    String generateInputQuery() {
        String query = "iSearch([[["; int rows = (int) gui.getRows().getValue(), cols= (int) gui.getCols().getValue();
        JButton buttons[][] = gui.getBtns();
        for(int i=0;i<rows;i++){
            query+="[";
            for(int j=0;j<cols;j++){
                query+=(buttons[i][j].getIcon() == null)?"*":"'O'";
                query+=(j<cols-1)?",":"";
            }
            query+=(i<rows -1)?"],":"]";
        }
          return query+"],null,0,0,0]],["+rows+","+cols+"],[],X,G)";
    }
    

    @Override
    String[] generateSolution() {
        Query q = new Query("consult('../Prolog implementation/board.pl'),consult('../Prolog implementation/informed.pl')"); 
       q.hasSolution();
        q= new Query(generateInputQuery());
        Map<String,Term>[] solutions = q.allSolutions(); 
        Set<String> ResultsSet = new HashSet<String>(); 
        for (Map<String, Term> sol :solutions) {
        String s = (sol.get("X").toString()); ResultsSet.add(s); }
       JLabel label =gui.getLabel(); label.setText("Maximum Dominoes: "+solutions[0].get("G"));
       return ResultsSet.toArray(new String[0]);
    }
    
}
