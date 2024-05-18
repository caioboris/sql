CREATE OR REPLACE PROCEDURE realizar_pedido (
    p_nom_cliente IN CLIENTE.NOM_CLIENTE%TYPE,
    p_des_razao_social IN CLIENTE.DES_RAZAO_SOCIAL%TYPE,
    p_tip_pessoa IN CLIENTE.TIP_PESSOA%TYPE,
    p_num_cpf_cnpj IN CLIENTE.NUM_CPF_CNPJ%TYPE,
    p_dat_cadastro IN DATE DEFAULT SYSDATE,
    p_dat_cancelamento IN DATE DEFAULT NULL,
    p_sta_ativo CLIENTE.STA_ATIVO%TYPE,
    p_  ITEM_PEDIDO.COD_PRODUTO, 
    p_qtd_produto -- Lista de quantidades correspondentes
) IS
    v_pedido_id      PEDIDOS.pedido_id%TYPE;
    v_estoque        PRODUTOS.estoque%TYPE;
    v_total_itens    NUMBER := p_itens.COUNT;
    
    -- Cursor para verificar o estoque de um produto
    CURSOR c_estoque (p_produto_id PRODUTOS.produto_id%TYPE) IS
        SELECT estoque
        FROM PRODUTOS
        WHERE produto_id = p_produto_id;
BEGIN
    -- Verifica se a quantidade de itens e quantidades são iguais
    IF p_itens.COUNT != p_quantidades.COUNT THEN
        RAISE_APPLICATION_ERROR(-20001, 'Número de itens e quantidades não correspondem.');
    END IF;
    
    -- Verificação do cliente
    DECLARE
        v_cliente_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cliente_count
        FROM CLIENTES
        WHERE cliente_id = p_cliente_id;
        
        IF v_cliente_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Cliente não encontrado.');
        END IF;
    END;
    
    -- Verificação do estoque
    FOR i IN 1..v_total_itens LOOP
        OPEN c_estoque(p_itens(i));
        FETCH c_estoque INTO v_estoque;
        CLOSE c_estoque;
        
        IF v_estoque IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Produto ' || p_itens(i) || ' não encontrado.');
        ELSIF v_estoque < p_quantidades(i) THEN
            RAISE_APPLICATION_ERROR(-20004, 'Estoque insuficiente para o produto ' || p_itens(i) || '.');
        END IF;
    END LOOP;
    
    -- Criação do pedido
    INSERT INTO PEDIDOS (pedido_id, cliente_id, data_pedido)
    VALUES (PEDIDOS_SEQ.NEXTVAL, p_cliente_id, SYSDATE)
    RETURNING pedido_id INTO v_pedido_id;
    
    -- Inserção dos itens do pedido
    FOR i IN 1..v_total_itens LOOP
        INSERT INTO ITENS_PEDIDO (pedido_id, produto_id, quantidade)
        VALUES (v_pedido_id, p_itens(i), p_quantidades(i));
        
        -- Atualização do estoque
        UPDATE PRODUTOS
        SET estoque = estoque - p_quantidades(i)
        WHERE produto_id = p_itens(i);
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido realizado com sucesso. ID do pedido: ' || v_pedido_id);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar o pedido: ' || SQLERRM);
END realizar_pedido;