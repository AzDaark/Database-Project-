/* Check points */ 

SELECT * 
FROM NOTE_AUTO_S204;

/* Gestion des droits */ ------------------------------------------------------

/* AnalyseJV */ 

BEGIN 
    FOR t in (
        SELECT table_name
        FROM user_tables
        WHERE table_name != 'LOG'
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || t.table_name || ' TO AnalyseJV'; 
    END LOOP;
END; 
/

BEGIN 
    FOR v in (
        SELECT view_name
        FROM user_views
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v.view_name || ' TO AnalyseJV'; 
    END LOOP;
END; 
/


/* GestionJV */ 

//SELECT
BEGIN 
    FOR t in (
        SELECT table_name
        FROM user_tables
        WHERE table_name != 'LOG'
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || t.table_name || ' TO GestionJV'; 
    END LOOP;
END; 
/

//INSERT

BEGIN 
    FOR t in (
        SELECT table_name
        FROM user_tables
        WHERE table_name != 'LOG'
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT INSERT ON ' || t.table_name || ' TO GestionJV'; 
    END LOOP;
END; 
/ 

// UPDATE

BEGIN 
    FOR t in (
        SELECT table_name
        FROM user_tables
        WHERE table_name != 'LOG'
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT UPDATE ON ' || t.table_name || ' TO GestionJV'; 
    END LOOP;
END; 
/

//DELETE 

BEGIN 
    FOR t in (
        SELECT table_name
        FROM user_tables
        WHERE table_name != 'LOG'
    )
    LOOP 
        EXECUTE IMMEDIATE 'GRANT DELETE ON ' || t.table_name || ' TO GestionJV'; 
    END LOOP;
END; 
/ 

/* Creation des vues */ -------------------------------------------------------

CREATE VIEW FICHE_JEU AS
SELECT 
    j.IdJeu AS identifiant,
    j.TitreJeu AS titre,
    TO_CHAR(j.DateMAJJeu, 'DD/MM/YY') AS premiere_date_sortie,
    CASE WHEN j.StatutJeu IS NULL THEN 'Publié' ELSE j.StatutJeu END AS statut,
    
   
    (SELECT LISTAGG(c.NomCompagnie, ', ') WITHIN GROUP (ORDER BY c.NomCompagnie) AS NomCompagnie
     FROM COMPAGNIE c
     JOIN COMPAGNIEJEU cj ON c.IdCompagnie = cj.IdCompagnie
     WHERE cj.IdJeu = j.IdJeu AND cj.EstDeveloppeur = 1) AS developpeurs,
    
    
    (SELECT LISTAGG(g.NomGenre, ', ') WITHIN GROUP (ORDER BY g.NomGenre) AS Genre
     FROM GENRE g
     JOIN GENREJEU gg ON g.IdGenre = gg.IdGenre
     WHERE gg.IdJeu = j.IdJeu) AS genres,
    
    (SELECT LISTAGG(p.NomPlateforme, ', ') WITHIN GROUP (ORDER BY p.NomPlateforme) AS Plateforme
     FROM PLATEFORME p
     JOIN DATESORTIE ds ON p.IdPlateforme = ds.IdPlateforme
     WHERE ds.IdJeu = j.IdJeu) AS plateformes,
    
    ROUND(j.ScoreJeu, 2) AS score_utilisateur,
    
   
    ROUND(j.ScoreIGDB, 2) AS score_critique
    
FROM JEU j
ORDER BY j.IdJeu ASC;
    




