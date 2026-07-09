-- =====================================================
-- SILVER: GEOLOCALIZACAO
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_geolocation_dataset
-- Grão  : 1 linha por CEP + coordenada (mesmo grão da bronze)
--
-- Transformação: padronização do nome do município
-- (geolocation_city) via CASE, cobrindo variações de acento,
-- hífen, apóstrofo e digitação (ex.: "sao paulo" / "são paulo"
-- / "sãopaulo" -> "SAO PAULO"). O dataset bruto tem centenas
-- de grafias distintas para o mesmo município; sem essa
-- normalização, qualquer agregação por cidade fica fragmentada.
--
-- Cidades sem regra explícita caem no ELSE (UPPER sem
-- tratamento de acento) para não travar o pipeline — a lista
-- cobre a Grande São Paulo, litoral, interior de SP e os
-- casos de nomes com apóstrofo (d'Oeste, d'Água etc.) mais
-- recorrentes no dataset.
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.geolocalizacao AS
SELECT
  geolocation_zip_code_prefix AS PREFIXO_CEP,
  geolocation_lat AS Latitude,
  geolocation_lng AS Longitude,

  CASE
    -- São Paulo capital
    WHEN geolocation_city IN (
        'sao paulo',
        'são paulo',
        'sãopaulo',
        'sp',
        'sa£o paulo'
    ) THEN 'SAO PAULO'

    -- São Bernardo do Campo
    WHEN geolocation_city IN (
        'sao bernardo do campo',
        'são bernardo do campo',
        'sbcampo'
    ) THEN 'SAO BERNARDO DO CAMPO'

    -- Santo André
    WHEN geolocation_city IN ('santo andre', 'santo andré') THEN 'SANTO ANDRE'

    -- São Caetano do Sul
    WHEN geolocation_city IN ('sao caetano do sul', 'são caetano do sul') THEN 'SAO CAETANO DO SUL'

    -- Diadema
    WHEN geolocation_city = 'diadema' THEN 'DIADEMA'

    -- Osasco (inclui "OSASCO-SP")
    WHEN geolocation_city IN ('osasco', 'osasco-sp') THEN 'OSASCO'

    -- Guarulhos (inclui "GUARULHOS-SP")
    WHEN geolocation_city IN ('guarulhos', 'guarulhos-sp') THEN 'GUARULHOS'

    -- Carapicuiba
    WHEN geolocation_city IN ('carapicuiba', 'carapicuíba') THEN 'CARAPICUIBA'

    -- Taboão da Serra
    WHEN geolocation_city IN ('taboao da serra', 'taboão da serra') THEN 'TABOAO DA SERRA'

    -- Cotia
    WHEN geolocation_city = 'cotia' THEN 'COTIA'

    -- Embu das Artes (separado de Embu-Guaçu)
    WHEN geolocation_city IN (
        'embu',
        'embu das artes'
    ) THEN 'EMBU DAS ARTES'

    -- Embu-Guaçu (município diferente!)
    WHEN geolocation_city IN (
        'embu-guacu',
        'embu-guaçu',
        'embu guaçu',
        'embu guacu',
        'embuguacu'
    ) THEN 'EMBU GUACU'

    -- Juquitiba
    WHEN geolocation_city = 'juquitiba' THEN 'JUQUITIBA'

    -- Santos
    WHEN geolocation_city = 'santos' THEN 'SANTOS'

    -- São Vicente
    WHEN geolocation_city IN ('sao vicente', 'são vicente') THEN 'SAO VICENTE'

    -- Guarujá
    WHEN geolocation_city IN ('guaruja', 'guarujá') THEN 'GUARUJA'

    -- Praia Grande
    WHEN geolocation_city = 'praia grande' THEN 'PRAIA GRANDE'

    -- Mongaguá
    WHEN geolocation_city IN ('mongagua', 'mongaguá') THEN 'MONGAGUA'

    -- Itanhaem
    WHEN geolocation_city IN ('itanhaem', 'itanhaém') THEN 'ITANHAEM'

    -- Peruibe
    WHEN geolocation_city IN ('peruibe', 'peruíbe') THEN 'PERUIBE'

    -- Itapecerica da Serra
    WHEN geolocation_city = 'itapecerica da serra' THEN 'ITAPECERICA DA SERRA'

    -- São Lourenço da Serra
    WHEN geolocation_city IN ('são lourenço da serra', 'sao lourenco da serra') THEN 'SAO LOURENCO DA SERRA'

    -- Vargem Grande Paulista
    WHEN geolocation_city = 'vargem grande paulista' THEN 'VARGEM GRANDE PAULISTA'

    -- Itapetininga
    WHEN geolocation_city = 'itapetininga' THEN 'ITAPETININGA'

    -- Sorocaba
    WHEN geolocation_city = 'sorocaba' THEN 'SOROCABA'

    -- São Roque
    WHEN geolocation_city IN ('sao roque', 'são roque') THEN 'SAO ROQUE'

    -- Mairiporã
    WHEN geolocation_city IN ('mairipora', 'mairiporã') THEN 'MAIRIPORA'

    -- Arujá
    WHEN geolocation_city IN ('aruja', 'arujá') THEN 'ARUJA'

    -- Santa Isabel
    WHEN geolocation_city = 'santa isabel' THEN 'SANTA ISABEL'

    -- Caieiras
    WHEN geolocation_city = 'caieiras' THEN 'CAIEIRAS'

    -- Cajamar
    WHEN geolocation_city = 'cajamar' THEN 'CAJAMAR'

    -- Franco da Rocha
    WHEN geolocation_city = 'franco da rocha' THEN 'FRANCO DA ROCHA'

    -- Francisco Morato
    WHEN geolocation_city = 'francisco morato' THEN 'FRANCISCO MORATO'

    -- Ribeirão Pires
    WHEN geolocation_city IN ('ribeirao pires', 'ribeirão pires') THEN 'RIBEIRAO PIRES'

    -- Rio Grande da Serra
    WHEN geolocation_city = 'rio grande da serra' THEN 'RIO GRANDE DA SERRA'

    -- Campinas
    WHEN geolocation_city = 'campinas' THEN 'CAMPINAS'

    -- Jundiaí
    WHEN geolocation_city IN ('jundiai', 'jundiaí') THEN 'JUNDIAI'

    -- Poá
    WHEN geolocation_city IN ('poa', 'poá') THEN 'POA'

    -- Mauá
    WHEN geolocation_city IN ('maua', 'mauá') THEN 'MAUA'

    -- Ferraz de Vasconcelos
    WHEN geolocation_city = 'ferraz de vasconcelos' THEN 'FERRAZ DE VASCONCELOS'

    -- Suzano
    WHEN geolocation_city = 'suzano' THEN 'SUZANO'

    -- Mogi das Cruzes
    WHEN geolocation_city IN ('mogi das cruzes', 'mogidascruzes') THEN 'MOGI DAS CRUZES'

    -- Itaquaquecetuba
    WHEN geolocation_city = 'itaquaquecetuba' THEN 'ITAQUAQUECETUBA'

    -- Salesópolis
    WHEN geolocation_city IN ('salesopolis', 'salesópolis') THEN 'SALESOPOLIS'

    -- Biritiba Mirim
    WHEN geolocation_city IN ('biritiba mirim', 'biritiba-mirim') THEN 'BIRITIBA MIRIM'

    -- Guararema
    WHEN geolocation_city = 'guararema' THEN 'GUARAREMA'

    -- Santana de Parnaíba
    WHEN geolocation_city IN ('santana de parnaiba', 'santana de parnaíba') THEN 'SANTANA DE PARNAIBA'

    -- Pirapora do Bom Jesus
    WHEN geolocation_city = 'pirapora do bom jesus' THEN 'PIRAPORA DO BOM JESUS'

    -- Barueri
    WHEN geolocation_city = 'barueri' THEN 'BARUERI'

    -- Jandira
    WHEN geolocation_city = 'jandira' THEN 'JANDIRA'

    -- Itapevi
    WHEN geolocation_city = 'itapevi' THEN 'ITAPEVI'

    -- Cubatão
    WHEN geolocation_city IN ('cubatao', 'cubatão') THEN 'CUBATAO'

    -- São Sebastião
    WHEN geolocation_city IN ('sao sebastiao', 'são sebastião') THEN 'SAO SEBASTIAO'

    -- Ubatuba
    WHEN geolocation_city = 'ubatuba' THEN 'UBATUBA'

    -- Ilhabela
    WHEN geolocation_city = 'ilhabela' THEN 'ILHABELA'

    -- Caraguatatuba
    WHEN geolocation_city = 'caraguatatuba' THEN 'CARAGUATATUBA'

    -- Bertioga
    WHEN geolocation_city = 'bertioga' THEN 'BERTIOGA'

    -- Registro
    WHEN geolocation_city = 'registro' THEN 'REGISTRO'

    -- Juquiá
    WHEN geolocation_city IN ('juquia', 'juquiá') THEN 'JUQUIA'

    -- Cananéia
    WHEN geolocation_city IN ('cananeia', 'cananéia') THEN 'CANANEIA'

    -- Iguape
    WHEN geolocation_city = 'iguape' THEN 'IGUAPE'

    -- Ilha Comprida
    WHEN geolocation_city = 'ilha comprida' THEN 'ILHA COMPRIDA'

    -- São José dos Campos
    WHEN geolocation_city IN ('sao jose dos campos', 'são josé dos campos') THEN 'SAO JOSE DOS CAMPOS'

    -- Taubaté
    WHEN geolocation_city IN ('taubate', 'taubaté') THEN 'TAUBATE'

    -- Jacareí
    WHEN geolocation_city IN ('jacarei', 'jacareí') THEN 'JACAREI'

    -- Caçapava
    WHEN geolocation_city IN ('cacapava', 'caçapava') THEN 'CACAPAVA'

    -- Tremembé
    WHEN geolocation_city IN ('tremembe', 'tremembé') THEN 'TREMEMBE'

    -- Pindamonhangaba
    WHEN geolocation_city = 'pindamonhangaba' THEN 'PINDAMONHANGABA'

    -- Guaratinguetá
    WHEN geolocation_city IN ('guaratingueta', 'guaratinguetá') THEN 'GUARATINGUETA'

    -- Lorena
    WHEN geolocation_city = 'lorena' THEN 'LORENA'

    -- Aparecida
    WHEN geolocation_city = 'aparecida' THEN 'APARECIDA'

    -- Campos do Jordão
    WHEN geolocation_city IN ('campos do jordao', 'campos do jordão') THEN 'CAMPOS DO JORDAO'

    -- São Bento do Sapucaí
    WHEN geolocation_city IN ('sao bento do sapucai', 'são bento do sapucaí') THEN 'SAO BENTO DO SAPUCAI'

    -- Cruzeiro
    WHEN geolocation_city = 'cruzeiro' THEN 'CRUZEIRO'

    -- Atibaia
    WHEN geolocation_city = 'atibaia' THEN 'ATIBAIA'

    -- Bragança Paulista
    WHEN geolocation_city IN ('braganca paulista', 'bragança paulista') THEN 'BRAGANCA PAULISTA'

    -- Piracaia
    WHEN geolocation_city = 'piracaia' THEN 'PIRACAIA'

    -- Nazaré Paulista
    WHEN geolocation_city IN ('nazare paulista', 'nazaré paulista') THEN 'NAZARE PAULISTA'

    -- Americana
    WHEN geolocation_city = 'americana' THEN 'AMERICANA'

    -- Santa Bárbara d'Oeste
    WHEN geolocation_city IN (
        'santa barbara d''oeste',
        'santa bárbara d''oeste',
        'santa barbara d oeste',
        'santa barbara doeste',
        'santa bárbara doeste',
        'santa bárbara d`oeste',
        'santa barbara d oeste'
    ) THEN 'SANTA BARBARA D OESTE'

    -- Dias d'Ávila
    WHEN geolocation_city IN (
        'dias d''avila',
        'dias d''ávila',
        'dias d avila',
        'dias d ávila'
    ) THEN 'DIAS D AVILA'

    -- Mirassol d'Oeste
    WHEN geolocation_city IN (
        'mirassol d''oeste',
        'mirassol d oeste'
    ) THEN 'MIRASSOL D OESTE'

    -- Herval d'Oeste
    WHEN geolocation_city IN (
        'herval d''oeste',
        'herval d oeste',
        'herval d'' oeste'
    ) THEN 'HERVAL D OESTE'

    -- Arraial d'Ajuda
    WHEN geolocation_city IN (
        'arraial d''ajuda',
        'arraial d ajuda'
    ) THEN 'ARRAIAL D AJUDA'

    -- Itapejara d'Oeste
    WHEN geolocation_city IN (
        'itapejara d''oeste',
        'itapejara d oeste'
    ) THEN 'ITAPEJARA D OESTE'

    -- Alta Floresta d'Oeste
    WHEN geolocation_city IN (
        'alta floresta d''oeste',
        'alta floresta d oeste'
    ) THEN 'ALTA FLORESTA D OESTE'

    -- Machadinho d'Oeste
    WHEN geolocation_city IN (
        'machadinho d''oeste',
        'machadinho d oeste'
    ) THEN 'MACHADINHO D OESTE'

    -- Palmeira d'Oeste
    WHEN geolocation_city IN (
        'palmeira d''oeste',
        'palmeira d oeste'
    ) THEN 'PALMEIRA D OESTE'

    -- Estrela d'Oeste
    WHEN geolocation_city IN (
        'estrela d''oeste',
        'estrela d oeste'
    ) THEN 'ESTRELA D OESTE'

    -- São Jorge d'Oeste
    WHEN geolocation_city IN (
        'sao jorge d''oeste',
        'são jorge d''oeste',
        'sao jorge d oeste',
        'são jorge d oeste'
    ) THEN 'SAO JORGE D OESTE'

    -- Figueirópolis d'Oeste
    WHEN geolocation_city IN (
        'figueiropolis d''oeste',
        'figueirópolis d''oeste',
        'figueiropolis d oeste',
        'figueirópolis d oeste'
    ) THEN 'FIGUEIROPOLIS D OESTE'

    -- Nova Brasilândia d'Oeste
    WHEN geolocation_city IN (
        'nova brasilandia d''oeste',
        'nova brasilândia d''oeste',
        'nova brasilandia d oeste',
        'nova brasilândia d oeste'
    ) THEN 'NOVA BRASILANDIA D OESTE'

    -- Alvorada d'Oeste
    WHEN geolocation_city IN (
        'alvorada d''oeste',
        'alvorada d oeste'
    ) THEN 'ALVORADA D OESTE'

    -- Conquista d'Oeste
    WHEN geolocation_city IN (
        'conquista d''oeste',
        'conquista d oeste'
    ) THEN 'CONQUISTA D OESTE'

    -- Aparecida d'Oeste
    WHEN geolocation_city IN (
        'aparecida d''oeste',
        'aparecida d oeste'
    ) THEN 'APARECIDA D OESTE'

    -- Olho d'Água das Flores
    WHEN geolocation_city IN (
        'olho d''agua das flores',
        'olho d''água das flores',
        'olho d agua das flores',
        'olho d água das flores'
    ) THEN 'OLHO D AGUA DAS FLORES'

    -- São João d'Aliança
    WHEN geolocation_city IN (
        'sao joao d''alianca',
        'são joão d''aliança',
        'sao joao d alianca',
        'são joão d aliança'
    ) THEN 'SAO JOAO D ALIANCA'

    -- Santa Clara d'Oeste
    WHEN geolocation_city IN (
        'santa clara d''oeste',
        'santa clara d oeste'
    ) THEN 'SANTA CLARA D OESTE'

    -- Santa Rita d'Oeste
    WHEN geolocation_city IN (
        'santa rita d''oeste',
        'santa rita d oeste'
    ) THEN 'SANTA RITA D OESTE'

    -- Guarani d'Oeste
    WHEN geolocation_city IN (
        'guarani d''oeste',
        'guarani d oeste'
    ) THEN 'GUARANI D OESTE'

    -- Olhos d'Água
    WHEN geolocation_city IN (
        'olhos d''agua',
        'olhos d''água',
        'olhos d agua',
        'olhos d água'
    ) THEN 'OLHOS D AGUA'

    -- Rancho Alegre d'Oeste
    WHEN geolocation_city IN (
        'rancho alegre d''oeste',
        'rancho alegre d oeste'
    ) THEN 'RANCHO ALEGRE D OESTE'

    -- Pérola d'Oeste
    WHEN geolocation_city IN (
        'perola d''oeste',
        'pérola d''oeste',
        'perola d oeste',
        'pérola d oeste'
    ) THEN 'PEROLA D OESTE'

    -- Lambari d'Oeste
    WHEN geolocation_city IN (
        'lambari d''oeste',
        'lambari d oeste'
    ) THEN 'LAMBARI D OESTE'

    -- Olho d'Agua das Cunhas
    WHEN geolocation_city IN (
        'olho d''agua das cunhas',
        'olho d''água das cunhãs',
        'olho d agua das cunhas',
        'olho d água das cunhãs'
    ) THEN 'OLHO D AGUA DAS CUNHAS'

    -- São João do Pau d'Alho
    WHEN geolocation_city IN (
        'sao joao do pau d''alho',
        'são joão do pau d''alho',
        'sao joao do pau d alho',
        'são joão do pau d alho'
    ) THEN 'SAO JOAO DO PAU D ALHO'

    -- Itaporanga d'Ajuda
    WHEN geolocation_city IN (
        'itaporanga d''ajuda',
        'itaporanga d ajuda'
    ) THEN 'ITAPORANGA D AJUDA'

    -- Diamante d'Oeste
    WHEN geolocation_city IN (
        'diamante d''oeste',
        'diamante d oeste'
    ) THEN 'DIAMANTE D OESTE'

    -- São Felipe d'Oeste
    WHEN geolocation_city IN (
        'sao felipe d''oeste',
        'são felipe d''oeste',
        'sao felipe d oeste',
        'são felipe d oeste'
    ) THEN 'SAO FELIPE D OESTE'

    -- Glória d'Oeste
    WHEN geolocation_city IN (
        'gloria d''oeste',
        'glória d''oeste',
        'gloria d oeste',
        'glória d oeste'
    ) THEN 'GLORIA D OESTE'

    -- Pau d'Arco
    WHEN geolocation_city IN (
        'pau d''arco',
        'pau d arco'
    ) THEN 'PAU D ARCO'

    -- Tanque d'Arca
    WHEN geolocation_city IN (
        'tanque d''arca',
        'tanque d arca'
    ) THEN 'TANQUE D ARCA'

    -- Mãe d'Água
    WHEN geolocation_city IN (
        'mae d''agua',
        'mãe d''água',
        'mae d agua',
        'mãe d água'
    ) THEN 'MAE D AGUA'

    -- Santa Luzia d'Oeste
    WHEN geolocation_city IN (
        'santa luzia d''oeste',
        'santa luzia d oeste'
    ) THEN 'SANTA LUZIA D OESTE'

    -- Barra d'Alcântara
    WHEN geolocation_city IN (
        'barra d''alcantara',
        'barra d''alcântara',
        'barra d alcantara',
        'barra d alcântara'
    ) THEN 'BARRA D ALCANTARA'

    -- Sant'Ana do Livramento
    WHEN geolocation_city IN (
        'sant''ana do livramento',
        'sant ana do livramento'
    ) THEN 'SANT ANA DO LIVRAMENTO'

    -- Olho d'Água do Casado
    WHEN geolocation_city IN (
        'olho d''água do casado',
        'olho d agua do casado'
    ) THEN 'OLHO D AGUA DO CASADO'

    -- Bandeirantes d'Oeste
    WHEN geolocation_city IN (
        'bandeirantes d''oeste',
        'bandeirantes d oeste'
    ) THEN 'BANDEIRANTES D OESTE'

    -- Lagoa d'Anta
    WHEN geolocation_city IN (
        'lagoa d''anta',
        'lagoa d anta'
    ) THEN 'LAGOA D ANTA'

    -- Sumaré
    WHEN geolocation_city IN ('sumare', 'sumaré') THEN 'SUMARE'

    -- Hortolândia
    WHEN geolocation_city IN ('hortolandia', 'hortolândia') THEN 'HORTOLANDIA'

    -- Paulínia
    WHEN geolocation_city IN ('paulinia', 'paulínia') THEN 'PAULINIA'

    -- Cosmópolis
    WHEN geolocation_city IN ('cosmopolis', 'cosmópolis') THEN 'COSMOPOLIS'

    -- Limeira
    WHEN geolocation_city = 'limeira' THEN 'LIMEIRA'

    -- Piracicaba
    WHEN geolocation_city = 'piracicaba' THEN 'PIRACICABA'

    -- Valinhos
    WHEN geolocation_city = 'valinhos' THEN 'VALINHOS'

    -- Vinhedo
    WHEN geolocation_city = 'vinhedo' THEN 'VINHEDO'

    -- Itatiba
    WHEN geolocation_city = 'itatiba' THEN 'ITATIBA'

    -- Indaiatuba
    WHEN geolocation_city = 'indaiatuba' THEN 'INDAIATUBA'

    -- Itu
    WHEN geolocation_city = 'itu' THEN 'ITU'

    -- Salto
    WHEN geolocation_city = 'salto' THEN 'SALTO'

    -- Rio Claro
    WHEN geolocation_city = 'rio claro' THEN 'RIO CLARO'

    -- São Carlos
    WHEN geolocation_city IN ('sao carlos', 'são carlos') THEN 'SAO CARLOS'

    -- Araraquara
    WHEN geolocation_city = 'araraquara' THEN 'ARARAQUARA'

    -- São Pedro
    WHEN geolocation_city IN ('sao pedro', 'são pedro') THEN 'SAO PEDRO'

    -- Águas de São Pedro
    WHEN geolocation_city IN ('aguas de sao pedro', 'águas de são pedro') THEN 'AGUAS DE SAO PEDRO'

    -- Araras
    WHEN geolocation_city = 'araras' THEN 'ARARAS'

    -- Pirassununga
    WHEN geolocation_city = 'pirassununga' THEN 'PIRASSUNUNGA'

    -- Porto Ferreira
    WHEN geolocation_city = 'porto ferreira' THEN 'PORTO FERREIRA'

    -- Leme
    WHEN geolocation_city = 'leme' THEN 'LEME'

    -- Mogi Guaçu
    WHEN geolocation_city IN ('mogi guacu', 'mogi guaçu', 'mogi-guacu') THEN 'MOGI GUACU'

    -- Mogi Mirim
    WHEN geolocation_city IN ('mogi mirim', 'mogi-mirim') THEN 'MOGI MIRIM'

    -- São João da Boa Vista
    WHEN geolocation_city IN ('sao joao da boa vista', 'são joão da boa vista') THEN 'SAO JOAO DA BOA VISTA'

    -- Águas da Prata
    WHEN geolocation_city IN ('aguas da prata', 'águas da prata') THEN 'AGUAS DA PRATA'

    -- Amparo
    WHEN geolocation_city = 'amparo' THEN 'AMPARO'

    -- Serra Negra
    WHEN geolocation_city = 'serra negra' THEN 'SERRA NEGRA'

    -- Águas de Lindóia
    WHEN geolocation_city IN ('aguas de lindoia', 'águas de lindóia', 'lindoia', 'lindóia') THEN 'AGUAS DE LINDOIA'

    -- Socorro
    WHEN geolocation_city = 'socorro' THEN 'SOCORRO'

    -- Itapira
    WHEN geolocation_city = 'itapira' THEN 'ITAPIRA'

    -- Ribeirão Preto
    WHEN geolocation_city IN ('ribeirao preto', 'ribeirão preto') THEN 'RIBEIRAO PRETO'

    -- Sertãozinho
    WHEN geolocation_city IN ('sertaozinho', 'sertãozinho') THEN 'SERTAOZINHO'

    -- Franca
    WHEN geolocation_city IN ('franca', 'franca sp') THEN 'FRANCA'

    -- Batatais
    WHEN geolocation_city = 'batatais' THEN 'BATATAIS'

    -- Barretos
    WHEN geolocation_city = 'barretos' THEN 'BARRETOS'

    -- São José do Rio Preto
    WHEN geolocation_city IN ('sao jose do rio preto', 'são josé do rio preto') THEN 'SAO JOSE DO RIO PRETO'

    -- Catanduva
    WHEN geolocation_city = 'catanduva' THEN 'CATANDUVA'

    -- Votuporanga
    WHEN geolocation_city = 'votuporanga' THEN 'VOTUPORANGA'

    -- Fernandópolis
    WHEN geolocation_city IN ('fernandopolis', 'fernandópolis') THEN 'FERNANDOPOLIS'

    -- Jales
    WHEN geolocation_city = 'jales' THEN 'JALES'

    -- Presidente Prudente
    WHEN geolocation_city = 'presidente prudente' THEN 'PRESIDENTE PRUDENTE'

    -- Marília
    WHEN geolocation_city IN ('marilia', 'marília') THEN 'MARILIA'

    -- Assis
    WHEN geolocation_city = 'assis' THEN 'ASSIS'

    -- Ourinhos
    WHEN geolocation_city = 'ourinhos' THEN 'OURINHOS'

    -- Avaré
    WHEN geolocation_city IN ('avare', 'avaré') THEN 'AVARE'

    -- Botucatu
    WHEN geolocation_city = 'botucatu' THEN 'BOTUCATU'

    -- Jaú
    WHEN geolocation_city IN ('jau', 'jaú') THEN 'JAU'

    -- Bauru
    WHEN geolocation_city = 'bauru' THEN 'BAURU'

    -- Lins
    WHEN geolocation_city = 'lins' THEN 'LINS'

    -- Araçatuba
    WHEN geolocation_city IN ('aracatuba', 'araçatuba') THEN 'ARACATUBA'

    -- Birigui
    WHEN geolocation_city = 'birigui' THEN 'BIRIGUI'

    -- Andradina
    WHEN geolocation_city = 'andradina' THEN 'ANDRADINA'

    -- Tatuí
    WHEN geolocation_city IN ('tatui', 'tatuí') THEN 'TATUI'

    -- Itapeva
    WHEN geolocation_city = 'itapeva' THEN 'ITAPEVA'

    -- Default: mantém em maiúsculo (sem tratamento de acento)
    -- para não travar o pipeline em municípios fora da lista.
    ELSE UPPER(geolocation_city)
  END AS cidade_padronizada,

  geolocation_state AS estado_padronizado
FROM seller_ops_mart.bronze.olist_geolocation_dataset;
