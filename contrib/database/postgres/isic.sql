CREATE SEQUENCE "isic_section_seq";
CREATE TABLE "isic_section" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('isic_section_seq'),
	"code" CHAR(1) NOT NULL CHECK ("code" ~ '^[a-uA-U]{1}$'),
	"name" VARCHAR(2048) NOT NULL CHECK ("name" <> ''),
	"description" TEXT NOT NULL CHECK ("description" <> ''),
	CONSTRAINT "isic_section_id_pkey" PRIMARY KEY ("id")
);


CREATE SEQUENCE "isic_division_seq";
CREATE TABLE "isic_division" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('isic_division_seq'),
	"code" INTEGER NOT NULL CHECK ("code" >= 01 AND "code" <= 99),
	"name" VARCHAR(2048) NOT NULL CHECK ("name" <> ''),
        "description" TEXT NOT NULL CHECK ("description" <> ''),
	CONSTRAINT "isic_division_id_pkey" PRIMARY KEY ("id")
);

CREATE SEQUENCE "isic_group_seq";
CREATE TABLE "isic_group" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('isic_group_seq'),
	"code" INTEGER NOT NULL CHECK ("code" >= 011 AND "code" <= 990),
	"name" VARCHAR(2048) NOT NULL CHECK ("name" <> ''),
        "description" TEXT NOT NULL CHECK ("description" <> ''),
	CONSTRAINT "isic_group_id_pkey" PRIMARY KEY ("id")
);

CREATE SEQUENCE "isic_class_seq";
CREATE TABLE "isic_class" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('isic_class_seq'),
	"code" INTEGER NOT NULL CHECK ("code" >= 0111 AND code <= 9900),
	"name" VARCHAR(2048) NOT NULL CHECK ("name" <> ''),
        "description" TEXT NOT NULL CHECK ("description" <> ''),	
	CONSTRAINT "isic_class_id_pkey" PRIMARY KEY ("id")
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'A', 'Agriculture, forestry and fishing', $$This section includes the exploitation of vegetal and animal natural resources, comprising the activities of growing of crops, raising and breeding of animals, harvesting of timber and other plants, animals or animal products from a farm or their natural habitats.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'B', 'Mining and quarrying', $$This section includes the extraction of minerals occurring naturally as solids (coal and ores), liquids (petroleum) or gases (natural gas). Extraction can be achieved by different methods such as underground or surface mining, well operation, seabed mining etc. This section also includes supplementary activities aimed at preparing the crude materials for marketing, for example, crushing, grinding, cleaning, drying, sorting, concentrating ores, liquefaction of natural gas and agglomeration of solid fuels. These operations are often carried out by the units that extracted the resource and/or others located nearby. Mining activities are classified into divisions, groups and classes on the basis of the principal mineral produced. Divisions 05, 06 are concerned with mining and quarrying of fossil fuels (coal, lignite, petroleum, gas); divisions 07, 08 concern metal ores, various minerals and quarry products. Some of the technical operations of this section, particularly related to the extraction of hydrocarbons, may also be carried out for third parties by specialized units as an industrial service, which is reflected in division 09. This section excludes the processing of the extracted materials (see section C - Manufacturing), which also covers the bottling of natural spring and mineral waters at springs and wells (see class 1104) or the crushing, grinding or otherwise treating certain earths, rocks and minerals not carried out in conjunction with mining and quarrying (see class 2399). This section also excludes the usage of the extracted materials without a further transformation for construction purposes (see section F - Construction), the collection, purification and distribution of water (see class 3600), separate site preparation activities for mining (see class 4312) and geophysical, geologic and seismic surveying activities (see class 7110).$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'C', 'Manufacturing',$$This section includes the physical or chemical transformation of materials, substances, or components into new products, although this cannot be used as the single universal criterion for defining manufacturing (see remark on processing of waste below). The materials, substances, or components transformed are raw materials that are products of agriculture, forestry, fishing, mining or quarrying as well as products of other manufacturing activities. Substantial alteration, renovation or reconstruction of goods is generally considered to be manufacturing. Units engaged in manufacturing are often described as plants, factories or mills and characteristically use power-driven machines and materials-handling equipment. However, units that transform materials or substances into new products by hand or in the worker's home and those engaged in selling to the general public of products made on the same premises from which they are sold, such as bakeries and custom tailors, are also included in this section. Manufacturing units may process materials or may contract with other units to process their materials for them. Both types of units are included in manufacturing. The output of a manufacturing process may be finished in the sense that it is ready for utilization or consumption, or it may be semi-finished in the sense that it is to become an input for further manufacturing. For example, the output of alumina refining is the input used in the primary production of aluminium; primary aluminium is the input to aluminium wire drawing; and aluminium wire is the input for the manufacture of fabricated wire products. Manufacture of specialized components and parts of, and accessories and attachments to, machinery and equipment is, as a general rule, classified in the same class as the manufacture of the machinery and equipment for which the parts and accessories are intended. Manufacture of unspecialized components and parts of machinery and equipment, e.g. engines, pistons, electric motors, electrical assemblies, valves, gears, roller bearings, is classified in the appropriate class of manufacturing, without regard to the machinery and equipment in which these items may be included. However, making specialized components and accessories by moulding or extruding plastics materials is included in class 2220. Assembly of the component parts of manufactured products is considered manufacturing. This includes the assembly of manufactured products from either self-produced or purchased components. The recovery of waste, i.e. the processing of waste into secondary raw materials is classified in class 3830 (Materials recovery). While this may involve physical or chemical transformations, this is not considered to be a part of manufacturing. The primary purpose of these activities is considered to be the treatment or processing of waste and they are therefore classified in Section E (Water supply; sewerage, waste management and remediation activities). However, the manufacture of new final products (as opposed to secondary raw materials) is classified in manufacturing, even if these processes use waste as an input. For example, the production of silver from film waste is considered to be a manufacturing process. Specialized maintenance and repair of industrial, commercial and similar machinery and equipment is, in general, classified in division 33 (Repair, maintenance and installation of machinery and equipment). However, the repair of computers and personal and household goods is classified in division 95 (Repair of computers and personal and household goods), while the repair of motor vehicles is classified in division 45 (Wholesale and retail trade and repair of motor vehicles and motorcycles). The installation of machinery and equipment, when carried out as a specialized activity, is classified in 3320. Remark: The boundaries of manufacturing and the other sectors of the classification system can be somewhat blurry. As a general rule, the activities in the manufacturing section involve the transformation of materials into new products. Their output is a new product. However, the definition of what constitutes a new product can be somewhat subjective. As clarification, the following activities are considered manufacturing in ISIC: - milk pasteurizing and bottling (see 1050) - fresh fish processing (oyster shucking, fish filleting), not done on a fishing boat (see 1020) - printing and related activities (see 1811, 1812) - ready-mixed concrete production (see 2395) - leather converting (see 1511) - wood preserving (see 1610) - electroplating, plating, metal heat treating, and polishing (see 2592) - rebuilding or remanufacturing of machinery (e.g. automobile engines, see 2910) - tyre retreading (see 2211) Conversely, there are activities that, although sometimes involving transformation processes, are classified in other sections of ISIC; in other words, they are not classified as manufacturing. They include: - logging, classified in section A (Agriculture, forestry and fishing); - beneficiating of agricultural products, classified in section A (Agriculture, forestry and fishing); - beneficiating of ores and other minerals, classified in section B (Mining and quarrying); - construction of structures and fabricating operations performed at the site of construction, classified in section F (Construction); - activities of breaking bulk and redistribution in smaller lots, including packaging, repackaging or bottling of products, such as liquors or chemicals; sorting of scrap; mixing of paints to customers' order; and cutting of metals to customers' order, producing a modified version of the same product, are classified to section G (Wholesale and retail trade; repair of motor vehicles and motorcycles).$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'D ', 'Electricity, gas, steam and air conditioning supply', $$This section includes the activity of providing electric power, natural gas, steam, hot water and the like through a permanent infrastructure (network) of lines, mains and pipes. The dimension of the network is not decisive; also included are the distribution of electricity, gas, steam, hot water and the like in industrial parks or residential buildings. This section therefore includes the operation of electric and gas utilities, which generate, control and distribute electric power or gas. Also included is the provision of steam and air-conditioning supply. This section excludes the operation of water and sewerage utilities, see 36, 37. This section also excludes the (typically long-distance) transport of gas through pipelines.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'E', 'Water supply; sewerage, waste management and remediation activities',$$This section includes activities related to the management (including collection, treatment and disposal) of various forms of waste, such as solid or non-solid industrial or household waste, as well as contaminated sites. The output of the waste or sewage treatment process can either be disposed of or become an input into other production processes. Activities of water supply are also grouped in this section, since they are often carried out in connection with, or by units also engaged in, the treatment of sewage.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'F',' Construction',$$This section includes general construction and specialized construction activities for buildings and civil engineering works. It includes new work, repair, additions and alterations, the erection of prefabricated buildings or structures on the site and also construction of a temporary nature. General construction is the construction of entire dwellings, office buildings, stores and other public and utility buildings, farm buildings etc., or the construction of civil engineering works such as motorways, streets, bridges, tunnels, railways, airfields, harbours and other water projects, irrigation systems, sewerage systems, industrial facilities, pipelines and electric lines, sports facilities etc. This work can be carried out on own account or on a fee or contract basis. Portions of the work and sometimes even the whole practical work can be subcontracted out. A unit that carries the overall responsibility for a construction project is classified here. Also included is the repair of buildings and engineering works. This section includes the complete construction of buildings (division 41), the complete construction of civil engineering works (division 42), as well as specialized construction activities, if carried out only as a part of the construction process (division 43). The renting of construction equipment with operator is classified with the specific construction activity carried out with this equipment. This section also includes the development of building projects for buildings or civil engineering works by bringing together financial, technical and physical means to realize the construction projects for later sale. If these activities are carried out not for later sale of the construction projects, but for their operation (e.g. renting of space in these buildings, manufacturing activities in these plants), the unit would not be classified here, but according to its operational activity, i.e. real estate, manufacturing etc.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'G', 'Wholesale and retail trade; repair of motor vehicles and motorcycles', $$This section includes wholesale and retail sale (i.e. sale without transformation) of any type of goods and the rendering of services incidental to the sale of these goods. Wholesaling and retailing are the final steps in the distribution of goods. Goods bought and sold are also referred to as merchandise. Also included in this section are the repair of motor vehicles and motorcycles. Sale without transformation is considered to include the usual operations (or manipulations) associated with trade, for example sorting, grading and assembling of goods, mixing (blending) of goods (for example sand), bottling (with or without preceding bottle cleaning), packing, breaking bulk and repacking for distribution in smaller lots, storage (whether or not frozen or chilled), cleaning and drying of agricultural products, cutting out of wood fibreboards or metal sheets as secondary activities. Division 45 includes all activities related to the sale and repair of motor vehicles and motorcycles, while divisions 46 and 47 include all other sale activities. The distinction between division 46 (wholesale) and division 47 (retail sale) is based on the predominant type of customer. Wholesale is the resale (sale without transformation) of new and used goods to retailers, to industrial, commercial, institutional or professional users, or to other wholesalers, or involves acting as an agent or broker in buying goods for, or selling goods to, such persons or companies. The principal types of businesses included are merchant wholesalers, i.e. wholesalers who take title to the goods they sell, such as wholesale merchants or jobbers, industrial distributors, exporters, importers, and cooperative buying associations, sales branches and sales offices (but not retail stores) that are maintained by manufacturing or mining units apart from their plants or mines for the purpose of marketing their products and that do not merely take orders to be filled by direct shipments from the plants or mines. Also included are merchandise brokers, commission merchants and agents and assemblers, buyers and cooperative associations engaged in the marketing of farm products. Wholesalers frequently physically assemble, sort and grade goods in large lots, break bulk, repack and redistribute in smaller lots, for example pharmaceuticals; store, refrigerate, deliver and install goods, engage in sales promotion for their customers and label design. Retailing is the resale (sale without transformation) of new and used goods mainly to the general public for personal or household consumption or utilization, by shops, department stores, stalls, mail-order houses, door-to-door sales persons, hawkers and peddlers, consumer cooperatives, auction houses etc. Most retailers take title to the goods they sell, but some act as agents for a principal and sell either on consignment or on a commission basis.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'H', 'Transportation and storage', $$This section includes the provision of passenger or freight transport, whether scheduled or not, by rail, pipeline, road, water or air and associated activities such as terminal and parking facilities, cargo handling, storage etc. Included in this section is the renting of transport equipment with driver or operator. Also included are postal and courier activities. This section excludes maintenance and repair of motor vehicles and other transportation equipment (see classes 4520 and 3315, respectively), the construction, maintenance and repair of roads, railroads, harbours, airfields (see classes 4210 and 4290), as well as the renting of transport equipment without driver or operator (see classes 7710 and 7730).$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'I','Accommodation and food service activities', $$This section includes the provision of short-stay accommodation for visitors and other travellers and the provision of complete meals and drinks fit for immediate consumption. The amount and type of supplementary services provided within this section can vary widely. This section excludes the provision of long-term accommodation as primary residences, which is classified in Real estate activities (section L). Also excluded is the preparation of food or drinks that are either not fit for immediate consumption or that are sold through independent distribution channels, i.e. through wholesale or retail trade activities. The preparation of these foods is classified in Manufacturing (section C).$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'J','Information and communication',$$This section includes the production and distribution of information and cultural products, the provision of the means to transmit or distribute these products, as well as data or communications, information technology activities and the processing of data and other information service activities. The main components of this section are publishing activities (division 58), including software publishing, motion picture and sound recording activities (division 59), radio and TV broadcasting and programming activities (division 60), telecommunications activities (division 61) and information technology activities (division 62) and other information service activities (division 63). Publishing includes the acquisition of copyrights to content (information products) and making this content available to the general public by engaging in (or arranging for) the reproduction and distribution of this content in various forms. All the feasible forms of publishing (in print, electronic or audio form, on the internet, as multimedia products such as CD-ROM reference books etc.) are included in this section. Activities related to production and distribution of TV programming span divisions 59, 60 and 61, reflecting different stages in this process. Individual components, such as movies, television series etc. are produced by activities in division 59, while the creation of a complete television channel programme, from components produced in division 59 or other components (such as live news programming) is included in division 60. Division 60 also includes the broadcasting of this programme by the producer. The distribution of the complete television programme by third parties, i.e. without any alteration of the content, is included in division 61. This distribution in division 61 can be done through broadcasting, satellite or cable systems.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'K','Financial and insurance activities', $$This section includes financial service activities, including insurance, reinsurance and pension funding activities and activities to support financial services. This section also includes the activities of holding assets, such as activities of holding companies and the activities of trusts, funds and similar financial entities.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'L', 'Real estate activities', $$This section includes acting as lessors, agents and/or brokers in one or more of the following: selling or buying real estate, renting real estate, providing other real estate services such as appraising real estate or acting as real estate escrow agents. Activities in this section may be carried out on own or leased property and may be done on a fee or contract basis. Also included is the building of structures, combined with maintaining ownership or leasing of such structures. This section includes real estate property managers.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'M', 'Professional, scientific and technical activities',$$This section includes specialized professional, scientific and technical activities. These activities require a high degree of training, and make specialized knowledge and skills available to users.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'N', 'Administrative and support service activities',$$This section includes a variety of activities that support general business operations. These activities differ from those in section M, since their primary purpose is not the transfer of specialized knowledge.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'O', 'Public administration and defence; compulsory social security', $$This section includes activities of a governmental nature, normally carried out by the public administration. This includes the enactment and judicial interpretation of laws and their pursuant regulation, as well as the administration of programmes based on them, legislative activities, taxation, national defence, public order and safety, immigration services, foreign affairs and the administration of government programmes. This section also includes compulsory social security activities. The legal or institutional status is not, in itself, the determining factor for an activity to belong in this section, rather than the activity being of a nature specified in the previous paragraph. This means that activities classified elsewhere in ISIC do not fall under this section, even if carried out by public entities. For example, administration of the school system (i.e. regulations, checks, curricula) falls under this section, but teaching itself does not (see section P), and a prison or military hospital is classified to health (see section Q). Similarly, some activities described in this section may be carried out by non-government units.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'P', 'Education', $$This section includes education at any level or for any profession, oral or written as well as by radio and television or other means of communication. It includes education by the different institutions in the regular school system at its different levels as well as adult education, literacy programmes etc. Also included are military schools and academies, prison schools etc. at their respective levels. The section includes public as well as private education. For each level of initial education, the classes include special education for physically or mentally handicapped pupils. The breakdown of the categories in this section is based on the level of education offered as defined by the levels of ISCED 1997. The activities of educational institutions providing education at ISCED levels 0 and 1 are classified in group 851, those at ISCED levels 2 and 3 in group 852 and those at ISCED levels 4, 5 and 6 in group 853. This section also includes instruction primarily concerned with sport and recreational activities such as bridge or golf and education support activities.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'Q', 'Human health and social work activities', $$This section includes the provision of health and social work activities. Activities include a wide range of activities, starting from health care provided by trained medical professionals in hospitals and other facilities, over residential care activities that still involve a degree of health care activities to social work activities without any involvement of health care professionals.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'R', 'Arts, entertainment and recreation', $$This section includes a wide range of activities to meet varied cultural, entertainment and recreational interests of the general public, including live performances, operation of museum sites, gambling, sports and recreation activities.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'S', 'Other service activities', $$This section (as a residual category) includes the activities of membership organizations, the repair of computers and personal and household goods and a variety of personal service activities not covered elsewhere in the classification.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'T','Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use', $$No explanatory note available for this code.$$
);

INSERT INTO "isic_section" (code,name,description) VALUES (
	'U', 'Activities of extraterritorial organizations and bodies',$$See class 9900.$$
);

--
--
--

INSERT INTO "isic_division" (code,name,description) VALUES (
	01,'Crop and animal production, hunting and related service activities', $$This division includes two basic activities, namely the production of crop products and production of animal products, covering also the forms of organic agriculture, the growing of genetically modified crops and the raising of genetically modified animals. This division also includes service activities incidental to agriculture, as well as hunting, trapping and related activities. Group 015 (Mixed farming) breaks with the usual principles for identifying main activity. It accepts that many agricultural holdings have reasonably balanced crop and animal production and that it would be arbitrary to classify them in one category or the other. Agricultural activities exclude any subsequent processing of the agricultural products (classified under divisions 10 and 11 (Manufacture of food products and beverages) and division 12 (Manufacture of tobacco products)), beyond that needed to prepare them for the primary markets. However, the preparation of products for the primary markets is included here. The division excludes field construction (e.g. agricultural land terracing, drainage, preparing rice paddies etc.) classified in section F (Construction) and buyers and cooperative associations engaged in the marketing of farm products classified in section G.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	02,'Forestry and logging', $$This division includes the production of roundwood for the forest-based manufacturing industries (ISIC divisions 16 and 17) as well as the extraction and gathering of wild growing non-wood forest products. Besides the production of timber, forestry activities result in products that undergo little processing, such as fire wood, charcoal, wood chips and roundwood used in an unprocessed form (e.g. pit-props, pulpwood etc.). These activities can be carried out in natural or planted forests.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	03,'Fishing and aquaculture', $$This division includes capture fishery and aquaculture, covering the use of fishery resources from marine, brackish or freshwater environments, with the goal of capturing or gathering fish, crustaceans, molluscs and other marine organisms and products (e.g. aquatic plants, pearls, sponges etc). Also included are activities that are normally integrated in the process of production for own account (e.g. seeding oysters for pearl production). This division does not include building and repairing of ships and boats (3011, 3315) and sport or recreational fishing activities (9319). Processing of fish, crustaceans or molluscs is excluded, whether at land-based plants or on factory ships (1020).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	05,'Mining of coal and lignite', $$This division includes the extraction of solid mineral fuels includes through underground or open-cast mining and includes operations (e.g. grading, cleaning, compressing and other steps necessary for transportation etc.) leading to a marketable product. This division does not include coking (see 1910), services incidental to coal or lignite mining (see 0990) or the manufacture of briquettes (see 1920).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	06,'Extraction of crude petroleum and natural gas', $$This division includes the production of crude petroleum, the mining and extraction of oil from oil shale and oil sands and the production of natural gas and recovery of hydrocarbon liquids. This includes the overall activities of operating and/or developing oil and gas field properties, including such activities as drilling, completing and equipping wells, operating separators, emulsion breakers, desilting equipment and field gathering lines for crude petroleum and all other activities in the preparation of oil and gas up to the point of shipment from the producing property. This division excludes support activities for petroleum and gas extraction, such as oil and gas field services, performed on a fee or contract basis, oil and gas well exploration and test drilling and boring activities (see class 0910). This division also excludes the refining of petroleum products (see class 1920) and geophysical, geologic and seismic surveying activities (see class 7110).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	07,'Mining of metal ores', $$This division includes mining for metallic minerals (ores), performed through underground or open-cast extraction, seabed mining etc. Also included are ore dressing and beneficiating operations, such as crushing, grinding, washing, drying, sintering, calcining or leaching ore, gravity separation or flotation operations. This division excludes manufacturing activities such as the roasting of iron pyrites (see class 2011), the production of aluminium oxide (see class 2420) and the operation of blast furnaces (see classes 2410 and 2420).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	08,'Other mining and quarrying', $$This division includes extraction from a mine or quarry, but also dredging of alluvial deposits, rock crushing and the use of salt marshes. The products are used most notably in construction (e.g. sands, stones etc.), manufacture of materials (e.g. clay, gypsum, calcium etc.), manufacture of chemicals etc. This division does not include processing (except crushing, grinding, cutting, cleaning, drying, sorting and mixing) of the minerals extracted.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	09,'Mining support service activities', $$This division includes specialized support services incidental to mining provided on a fee or contract basis. It includes exploration services through traditional prospecting methods such as taking core samples and making geological observations as well as drilling, test-drilling or redrilling for oil wells, metallic and non-metallic minerals. Other typical services cover building oil and gas well foundations, cementing oil and gas well casings, cleaning, bailing and swabbing oil and gas wells, draining and pumping mines, overburden removal services at mines, etc.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	10,'Manufacture of food products', $$This division includes the processing of the products of agriculture, forestry and fishing into food for humans or animals, and includes the production of various intermediate products that are not directly food products. The activity often generates associated products of greater or lesser value (for example, hides from slaughtering, or oilcake from oil production). This division is organized by activities dealing with different kinds of products: meat, fish, fruit and vegetables, fats and oils, milk products, grain mill products, animal feeds and other food products. Production can be carried out for own account, as well as for third parties, as in custom slaughtering. Some activities are considered manufacturing (for example, those performed in bakeries, pastry shops, and prepared meat shops etc. which sell their own production) even though there is retail sale of the products in the producers' own shop. However, where the processing is minimal and does not lead to a real transformation, the unit is classified to Wholesale and retail trade (section G). Production of animal feeds from slaughter waste or by-products is classified in 1080, while processing food and beverage waste into secondary raw material is classified to 3830, and disposal of food and beverage waste in 3821.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	11,'Manufacture of beverages', $$This division includes the processing of an agricultural product, tobacco, into a form suitable for final consumption.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	12,'Manufacture of tobacco products', $$This division includes the processing of an agricultural product, tobacco, into a form suitable for final consumption.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	13,'Manufacture of textiles', $$This division includes preparation and spinning of textile fibres as well as textile weaving, finishing of textiles and wearing apparel, manufacture of made-up textile articles, except apparel (e.g. household linen, blankets, rugs, cordage etc.). Growing of natural fibres is covered under division 01, while manufacture of synthetic fibres is a chemical process classified in class 2030. Manufacture of wearing apparel is covered in division 14.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	14,'Manufacture of wearing apparel', $$This division includes all tailoring (ready-to-wear or made-to-measure), in all materials (e.g. leather, fabric, knitted and crocheted fabrics etc.), of all items of clothing (e.g. outerwear, underwear for men, women or children; work, city or casual clothing etc.) and accessories. There is no distinction made between clothing for adults and clothing for children, or between modern and traditional clothing. Division 14 also includes the fur industry (fur skins and wearing apparel).$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	15,'Manufacture of leather and related products', $$This division includes dressing and dyeing of fur and the transformation of hides into leather by tanning or curing and fabricating the leather into products for final consumption. It also includes the manufacture of similar products from other materials (imitation leathers or leather substitutes), such as rubber footwear, textile luggage etc. The products made from leather substitutes are included here, since they are made in ways similar to those in which leather products are made (e.g. luggage) and are often produced in the same unit.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	16,'Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials', $$This division includes the manufacture of wood products, such as lumber, plywood, veneers, wood containers, wood flooring, wood trusses, and prefabricated wood buildings. The production processes include sawing, planing, shaping, laminating, and assembling of wood products starting from logs that are cut into bolts, or lumber that may then be cut further, or shaped by lathes or other shaping tools. The lumber or other transformed wood shapes may also be subsequently planed or smoothed, and assembled into finished products, such as wood containers. With the exception of sawmilling, this division is subdivided mainly based on the specific products manufactured. This division does not include the manufacture of furniture (3100), or the installation of wooden fittings and the like (4330).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	17,'Manufacture of paper and paper products', $$This division includes the manufacture of pulp, paper and converted paper products. The manufacture of these products is grouped together because they constitute a series of vertically connected processes. More than one activity is often carried out in a single unit. There are essentially three activities: The manufacture of pulp involves separating the cellulose fibers from other impurities in wood or used paper. The manufacture of paper involves matting these fibers into a sheet. Converted paper products are made from paper and other materials by various cutting and shaping techniques, including coating and laminating activities. The paper articles may be printed (e.g. wallpaper, gift wrap etc.), as long as the printing of information is not the main purpose. The production of pulp, paper and paperboard in bulk is included in class 1701, while the remaining classes include the production of further-processed paper and paper products.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	18,'Printing and reproduction of recorded media', $$This division includes printing of products, such as newspapers, books, periodicals, business forms, greeting cards, and other materials, and associated support activities, such as bookbinding, plate-making services, and data imaging. The support activities included here are an integral part of the printing industry, and a product (a printing plate, a bound book, or a computer disk or file) that is an integral part of the printing industry is almost always provided by these operations. Processes used in printing include a variety of methods for transferring an image from a plate, screen, or computer file to a medium, such as paper, plastics, metal, textile articles, or wood. The most prominent of these methods entails the transfer of the image from a plate or screen to the medium through lithographic, gravure, screen or flexographic printing. Often a computer file is used to directly ''drive'' the printing mechanism to create the image or electrostatic and other types of equipment (digital or non-impact printing). Though printing and publishing can be carried out by the same unit (a newspaper, for example), it is less and less the case that these distinct activities are carried out in the same physical location. This division also includes the reproduction of recorded media, such as compact discs, video recordings, software on discs or tapes, records etc. This division excludes publishing activities (see section J).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	19,'Manufacture of coke and refined petroleum products', $$This division includes the transformation of crude petroleum and coal into usable products. The dominant process is petroleum refining, which involves the separation of crude petroleum into component products through such techniques as cracking and distillation. This division also includes the manufacture for own account of characteristic products (e.g. coke, butane, propane, petrol, kerosene, fuel oil etc.) as well as processing services (e.g. custom refining). This division includes the manufacture of gases such as ethane, propane and butane as products of petroleum refineries. Not included is the manufacture of such gases in other units (2011), manufacture of industrial gases (2011), extraction of natural gas (methane, ethane, butane or propane) (0600), and manufacture of fuel gas, other than petroleum gases (e.g. coal gas, water gas, producer gas, gasworks gas) (35420). The manufacture of petrochemicals from refined petroleum is classified in division 20.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	20,'Manufacture of chemicals and chemical products', $$This division includes the transformation of organic and inorganic raw materials by a chemical process and the formation of products. It distinguishes the production of basic chemicals that constitute the first industry group from the production of intermediate and end products produced by further processing of basic chemicals that make up the remaining industry classes.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	21,'Manufacture of basic pharmaceutical products and pharmaceutical preparations', $$This division includes the manufacture of basic pharmaceutical products and pharmaceutical preparations. This includes also the manufacture of medicinal chemical and botanical products.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	22,'Manufacture of rubber and plastics products', $$This division includes the manufacture of rubber and plastics products. This division is characterized by the raw materials used in the manufacturing process. However, this does not imply that the manufacture of all products made of these materials is classified here.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	23,'Manufacture of other non-metallic mineral products', $$This division includes manufacturing activities related to a single substance of mineral origin. This division includes the manufacture of glass and glass products (e.g. flat glass, hollow glass, fibres, technical glassware etc.), ceramic products, tiles and baked clay products, and cement and plaster, from raw materials to finished articles. The manufacture of shaped and finished stone and other mineral products is also included in this division.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	24,'Manufacture of basic metals', $$This division includes the activities of smelting and/or refining ferrous and non-ferrous metals from ore, pig or scrap, using electrometallurgic and other process metallurgic techniques. This division also includes the manufacture of metal alloys and super-alloys by introducing other chemical elements to pure metals. The output of smelting and refining, usually in ingot form, is used in rolling, drawing and extruding operations to make products such as plate, sheet, strip, bars, rods, wire, tubes, pipes and hollow profiles, and in molten form to make castings and other basic metal products.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	25,'Manufacture of fabricated metal products, except machinery and equipment', $$This division includes the manufacture of "pure" metal products (such as parts, containers and structures), usually with a static, immovable function, as opposed to the following divisions 26-30, which cover the manufacture of combinations or assemblies of such metal products (sometimes with other materials) into more complex units that, unless they are purely electrical, electronic or optical, work with moving parts. The manufacture of weapons and ammunition is also included in this division. This division excludes specialized repair and maintenance activities (see group 331) and the specialized installation of manufactured goods produced in this division in buildings, such as central heating boilers (see 4322).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	26,'Manufacture of computer, electronic and optical products', $$This division includes the manufacture of computers, computer peripherals, communications equipment, and similar electronic products, as well as the manufacture of components for such products. Production processes of this division are characterized by the design and use of integrated circuits and the application of highly specialized miniaturization technologies. The division also contains the manufacture of consumer electronics, measuring, testing, navigating, and control equipment, irradiation, electromedical and electrotherapeutic equipment, optical instruments and equipment, and the manufacture of magnetic and optical media.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	27,'Manufacture of electrical equipment', $$This division includes the manufacture of products that generate, distribute and use electrical power. Also included is the manufacture of electrical lighting, signalling equipment and electric household appliances. This division excludes the manufacture of electronic products (see division 26).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	28,'Manufacture of machinery and equipment n.e.c.', $$This division includes the manufacture of machinery and equipment that act independently on materials either mechanically or thermally or perform operations on materials (such as handling, spraying, weighing or packing), including their mechanical components that produce and apply force, and any specially manufactured primary parts. This includes the manufacture of fixed and mobile or hand-held devices, regardless of whether they are designed for industrial, building and civil engineering, agricultural or home use. The manufacture of special equipment for passenger or freight transport within demarcated premises also belongs within this division. This division distinguishes between the manufacture of special-purpose machinery, i.e. machinery for exclusive use in an ISIC industry or a small cluster of ISIC industries, and general-purpose machinery, i.e. machinery that is being used in a wide range of ISIC industries. This division also includes the manufacture of other special-purpose machinery, not covered elsewhere in the classification, whether or not used in a manufacturing process, such as fairground amusement equipment, automatic bowling alley equipment, etc. This division excludes the manufacture of metal products for general use (division 25), associated control devices, computer equipment, measurement and testing equipment, electricity distribution and control apparatus (divisions 26 and 27) and general-purpose motor vehicles (divisions 29 and 30).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	29,'Manufacture of motor vehicles, trailers and semi-trailers', $$This division includes the manufacture of motor vehicles for transporting passengers or freight. The manufacture of various parts and accessories, as well as the manufacture of trailers and semi-trailers, is included here. The maintenance and repair of vehicles produced in this division are classified in 4520.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	30,'Manufacture of other transport equipment', $$This division includes the manufacture of transportation equipment such as ship building and boat manufacturing, the manufacture of railroad rolling stock and locomotives, air and spacecraft and the manufacture of parts thereof.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	31,'Manufacture of furniture', $$This division includes the manufacture of furniture and related products of any material except stone, concrete and ceramic. The processes used in the manufacture of furniture are standard methods of forming materials and assembling components, including cutting, moulding and laminating. The design of the article, for both aesthetic and functional qualities, is an important aspect of the production process. Some of the processes used in furniture manufacturing are similar to processes that are used in other segments of manufacturing. For example, cutting and assembly occurs in the production of wood trusses that are classified in division 16 (Manufacture of wood and wood products). However, the multiple processes distinguish wood furniture manufacturing from wood product manufacturing. Similarly, metal furniture manufacturing uses techniques that are also employed in the manufacturing of roll-formed products classified in division 25 (Manufacture of fabricated metal products). The molding process for plastics furniture is similar to the molding of other plastics products. However, the manufacture of plastics furniture tends to be a specialized activity.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	32,'Other manufacturing', $$This division includes the manufacture of a variety of goods not covered in other parts of the classification. Since this is a residual division, production processes, input materials and use of the produced goods can vary widely and usual criteria for grouping classes into divisions have not been applied here.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	33,'Repair and installation of machinery and equipment', $$This division includes the specialized repair of goods produced in the manufacturing sector with the aim to restore machinery, equipment and other products to working order. The provision of general or routine maintenance (i.e. servicing) on such products to ensure they work efficiently and to prevent breakdown and unnecessary repairs is included. This division does only include specialized repair and maintenance activities. A substantial amount of repair is also done by manufacturers of machinery, equipment and other goods, in which case the classification of units engaged in these repair and manufacturing activities is done according to the value-added principle which would often assign these combined activities to the manufacture of the good. The same principle is applied for combined trade and repair. The rebuilding or remanufacturing of machinery and equipment is considered a manufacturing activity and included in other divisions of this section. Repair and maintenance of goods that are utilized as capital goods as well as consumer goods is typically classified as repair and maintenance of household goods (e.g. office and household furniture repair, see 9524). Also included in this division is the specialized installation of machinery. However, the installation of equipment that forms an integral part of buildings or similar structures, such as installation of electrical wiring, installation of escalators or installation of air-conditioning systems, is classified as construction. This division excludes the cleaning of industrial machinery (see class 8129) and the repair and maintenance of computers, communications equipment and household goods (see division 95).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	35,'Electricity, gas, steam and air conditioning supply', $$See section D.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	36,'Water collection, treatment and supply', $$This division includes the collection, treatment and distribution of water for domestic and industrial needs. Collection of water from various sources, as well as distribution by various means is included.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	37,'Sewerage', $$This division includes the operation of sewer systems or sewage treatment facilities that collect, treat, and dispose of sewage.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	38,'Waste collection, treatment and disposal activities; materials recovery', $$This division includes the collection, treatment, and disposal of waste materials. This also includes local hauling of waste materials and the operation of materials recovery facilities (i.e. those that sort recoverable materials from a waste stream).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	39,'Remediation activities and other waste management services', $$This division includes the provision of remediation services, i.e. the cleanup of contaminated buildings and sites, soil, surface or ground water.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	41,'Construction of buildings', $$This division includes general construction of buildings of all kinds. It includes new work, repair, additions and alterations, the erection of pre-fabricated buildings or structures on the site and also construction of temporary nature. Included is the construction of entire dwellings, office buildings, stores and other public and utility buildings, farm buildings, etc.$$ 
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	42,'Civil engineering', $$This division includes general construction for civil engineering objects. It includes new work, repair, additions and alterations, the erection of pre-fabricated structures on the site and also construction of temporary nature. Included is the construction of heavy constructions such as motorways, streets, bridges, tunnels, railways, airfields, harbours and other water projects, irrigation systems, sewerage systems, industrial facilities, pipelines and electric lines, outdoor sports facilities, etc. This work can be carried out on own account or on a fee or contract basis. Portions of the work and sometimes even the whole practical work can be subcontracted out.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	43,'Specialized construction activities', $$This division includes specialized construction activities (special trades), i.e. the construction of parts of buildings and civil engineering works without responsibility for the entire project. These activities are usually specialized in one aspect common to different structures, requiring specialized skills or equipment, such as pile driving, foundation work, carcass work, concrete work, brick laying, stone setting, scaffolding, roof covering, etc. The erection of steel structures is included, provided that the parts are not produced by the same unit. Specialized construction activities are mostly carried out under subcontract, but especially in repair construction it is done directly for the owner of the property. Also included are building finishing and building completion activities. Included is the installation of all kind of utilities that make the construction function as such. These activities are usually performed at the site of the construction, although parts of the job may be carried out in a special shop. Included are activities such as plumbing, installation of heating and air-conditioning systems, antennas, alarm systems and other electrical work, sprinkler systems, elevators and escalators, etc. Also included are insulation work (water, heat, sound), sheet metal work, commercial refrigerating work, the installation of illumination and signalling systems for roads, railways, airports, harbours, etc. Also included is the repair of the same type as the above-mentioned activities. Building completion activities encompass activities that contribute to the completion or finishing of a construction such as glazing, plastering, painting, floor and wall tiling or covering with other materials like parquet, carpets, wallpaper, etc., floor sanding, finish carpentry, acoustical work, cleaning of the exterior, etc. Also included is the repair of the same type as the above-mentioned activities. The renting of construction equipment with operator is classified with the associated construction activity.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	45,'Wholesale and retail trade and repair of motor vehicles and motorcycles', $$This division includes all activities (except manufacture and renting) related to motor vehicles and motorcycles, including lorries and trucks, such as the wholesale and retail sale of new and second-hand vehicles, the repair and maintenance of vehicles and the wholesale and retail sale of parts and accessories for motor vehicles and motorcycles. Also included are activities of commission agents involved in wholesale or retail sale of vehicles. This division also includes activities such as washing, polishing of vehicles etc. This division does not include the retail sale of automotive fuel and lubricating or cooling products or the renting of motor vehicles or motorcycles.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	46,'Wholesale trade, except of motor vehicles and motorcycles', $$This division includes wholesale trade on own account or on a fee or contract basis (commission trade) related to domestic wholesale trade as well as international wholesale trade (import/export). Wholesale is the resale (sale without transformation) of new and used goods to retailers, business-to-business trade, such as to industrial, commercial, institutional or professional users, or resale to other wholesalers, or involves acting as an agent or broker in buying goods for, or selling goods to, such persons or companies. The principal types of businesses included are merchant wholesalers, i.e. wholesalers who take title to the goods they sell, such as wholesale merchants or jobbers, industrial distributors, exporters, importers, and cooperative buying associations, sales branches and sales offices (but not retail stores) that are maintained by manufacturing or mining units apart from their plants or mines for the purpose of marketing their products and that do not merely take orders to be filled by direct shipments from the plants or mines. Also included are merchandise brokers, commission merchants and agents and assemblers, buyers and cooperative associations engaged in the marketing of farm products. Wholesalers frequently physically assemble, sort and grade goods in large lots, break bulk, repack and redistribute in smaller lots, for example pharmaceuticals; store, refrigerate, deliver and install goods, engage in sales promotion for their customers and label design. This division excludes the wholesale of motor vehicles, caravans and motorcycles, as well as motor vehicle accessories (see division 45), the renting and leasing of goods (see division 77) and the packing of solid goods and bottling of liquid or gaseous goods, including blending and filtering, for third parties (see class 8292).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	47,'Retail trade, except of motor vehicles and motorcycles', $$This division includes the resale (sale without transformation) of new and used goods mainly to the general public for personal or household consumption or utilization, by shops, department stores, stalls, mail-order houses, hawkers and peddlers, consumer cooperatives etc. Retail trade is classified first by type of sale outlet (retail trade in stores: groups 471 to 477; retail trade not in stores: groups 478 and 479). Retail trade in stores includes the retail sale of used goods (class 4774). For retail sale in stores, there exists a further distinction between specialized retail sale (groups 472 to 477) and non-specialized retail sale (group 471). The above groups are further subdivided by the range of products sold. Sale not via stores is subdivided according to the forms of trade, such as retail sale via stalls and markets (group 478) and other non-store retail sale, e.g. mail order, door-to-door, by vending machines etc. (group 479). The goods sold in this division are limited to goods usually referred to as consumer goods or retail goods. Therefore goods not usually entering the retail trade, such as cereal grains, ores, industrial machinery etc., are excluded. This division also includes units engaged primarily in selling to the general public, from displayed goods, products such as personal computers, stationery, paint or timber, although these sales may not be for personal or household use. Some processing of goods may be involved, but only incidental to selling, e.g. sorting or repackaging of goods, installation of a domestic appliance etc. This division also includes the retail sale by commission agents and activities of retail auctioning houses. This division excludes: - sale of farmers' products by farmers, see division 01 - manufacture and sale of goods, which is generally classified as manufacturing in divisions 10-32 - sale of motor vehicles, motorcycles and their parts, see division 45 - trade in cereal grains, ores, crude petroleum, industrial chemicals, iron and steel and industrial machinery and equipment, see division 46 - sale of food and drinks for consumption on the premises and sale of takeaway food, see division 56 - renting of personal and household goods to the general public, see group 772$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	49,'Land transport and transport via pipelines', $$This division includes the transport of passengers and freight via road and rail, as well as freight transport via pipelines.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	50,'Water transport', $$This division includes the transport of passengers or freight over water, whether scheduled or not. Also included are the operation of towing or pushing boats, excursion, cruise or sightseeing boats, ferries, water taxis etc. Although the location is an indicator for the separation between sea and inland water transport, the deciding factor is the type of vessel used. All transport on sea-going vessels is classified in group 501, while transport using other vessels is classified in group 502. This division excludes restaurant and bar activities on board ships (see class 5610, 5630), if carried out by separate units.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	51,'Air transport', $$This division includes the transport of passengers or freight by air or via space. This division excludes the repair of aircraft or aircraft engines (see class 3315) and support activities, such as the operation of airports, (see class 5223). This division also excludes activities that make use of aircraft, but not for the purpose of transportation, such as crop spraying (see class 0161), aerial advertising (see class 7310) or aerial photography (see class 7420).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	52,'Warehousing and support activities for transportation', $$This division includes warehousing and support activities for transportation, such as operating of transport infrastructure (e.g. airports, harbours, tunnels, bridges, etc.), the activities of transport agencies and cargo handling.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	53,'Postal and courier activities', $$This division includes postal and courier activities, such as pickup, transport and delivery of letters and parcels under various arrangements. Local delivery and messenger services are also included.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	55,'Accommodation', $$This division includes the provision of short-stay accommodation for visitors and other travellers. Also included is the provision of longer-term accommodation for students, workers and similar individuals. Some units may provide only accommodation while others provide a combination of accommodation, meals and/or recreational facilities. This division excludes activities related to the provision of long-term primary residences in facilities such as apartments typically leased on a monthly or annual basis classified in Real Estate (section L).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	56,'Food and beverage service activities', $$This division includes food and beverage serving activities providing complete meals or drinks fit for immediate consumption, whether in traditional restaurants, self-service or take-away restaurants, whether as permanent or temporary stands with or without seating. Decisive is the fact that meals fit for immediate consumption are offered, not the kind of facility providing them. Excluded is the production of meals not fit for immediate consumption or not planned to be consumed immediately or of prepared food which is not considered to be a meal (see divisions 10: Manufacture of food products and 11: Manufacture of beverages). Also excluded is the sale of not self-manufactured food that is not considered to be a meal or of meals that are not fit for immediate consumption (see section G: Wholesale and retail trade; ...).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	58,'Publishing activities', $$This division includes the publishing of books, brochures, leaflets, dictionaries, encyclopaedias, atlases, maps and charts; publishing of newspapers, journals and periodicals; directory and mailing list and other publishing, as well as software publishing. Publishing includes the acquisition of copyrights to content (information products) and making this content available to the general public by engaging in (or arranging for) the reproduction and distribution of this content in various forms. All the feasible forms of publishing (in print, electronic or audio form, on the Internet, as multimedia products such as CD-ROM reference books etc.), except publishing of motion pictures, are included in this division. This division excludes the publishing of motion pictures, video tapes and movies on DVD or similar media (division 59) and the production of master copies for records or audio material (division 59). Also excluded are printing (see 1811) and the mass reproduction of recorded media (see 1820).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	59 ,'Motion picture, video and television programme production, sound recording and music publishing activities', $$This division includes production of theatrical and non-theatrical motion pictures whether on film, videotape or disc for direct projection in theatres or for broadcasting on television; supporting activities such as film editing, cutting, dubbing etc.; distribution of motion pictures and other film productions to other industries; as well as motion picture or other film productions projection. Also included is the buying and selling of distribution rights for motion pictures or other film productions. This division also includes the sound recording activities, i.e. production of original sound master recordings, releasing, promoting and distributing them, publishing of music as well as sound recording service activities in a studio or elsewhere.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	60,'Programming and broadcasting activities', $$This division includes the activities of creating content or acquiring the right to distribute content and subsequently broadcasting that content, such as radio, television and data programs of entertainment, news, talk, and the like. Also included is data broadcasting, typically integrated with radio or TV broadcasting. The broadcasting can be performed using different technologies, over-the-air, via satellite, via a cable network or via Internet. This division also includes the production of programs that are typically narrowcast in nature (limited format, such as news, sports, education or youth-oriented programming) on a subscription or fee basis, to a third party, for subsequent broadcasting to the public. This division excludes the distribution of cable and other subscription programming (see division 61).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	61,'Telecommunications', $$This division includes the activities of providing telecommunications and related service activities, i.e. transmitting voice, data, text, sound and video. The transmission facilities that carry out these activities may be based on a single technology or a combination of technologies. The commonality of activities classified in this division is the transmission of content, without being involved in its creation. The breakdown in this division is based on the type of infrastructure operated. In the case of transmission of television signals this may include the bundling of complete programming channels (produced in division 60) in to programme packages for distribution.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	62 ,'Computer programming, consultancy and related activities', $$This division includes the following activities of providing expertise in the field of information technologies: writing, modifying, testing and supporting software; planning and designing computer systems that integrate computer hardware, software and communication technologies; on-site management and operation of clients' computer systems and/or data processing facilities; and other professional and technical computer-related activities.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	63 ,'Information service activities', $$This division includes the activities of web search portals, data processing and hosting activities, as well as other activities that primarily supply information.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	64,'Financial service activities, except insurance and pension funding', $$This division includes the activities of obtaining and redistributing funds other than for the purpose of insurance or pension funding or compulsory social security. Note: National institutional arrangements are likely to play a significant role in determining the classification within this division.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	65,'Insurance, reinsurance and pension funding, except compulsory social security', $$This division includes the underwriting annuities and insurance policies and investing premiums to build up a portfolio of financial assets to be used against future claims. Provision of direct insurance and reinsurance are included.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	66,'Activities auxiliary to financial service and insurance activities', $$This division includes the provision of services involved in or closely related to financial service activities, but not themselves providing financial services. The primary breakdown of this division is according to the type of financial transaction or funding served.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	68,'Real estate activities', $$See section L.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	69,'Legal and accounting activities', $$This division includes legal representation of one party's interest against another party, whether or not before courts or other judicial bodies by, or under supervision of, persons who are members of the bar, such as advice and representation in civil cases, advice and representation in criminal actions, advice and representation in connection with labour disputes. It also includes preparation of legal documents such as articles of incorporation, partnership agreements or similar documents in connection with company formation, patents and copyrights, preparation of deeds, wills, trusts, etc. as well as other activities of notaries public, civil law notaries, bailiffs, arbitrators, examiners and referees. It also includes accounting and bookkeeping services such as auditing of accounting records, preparing financial statements and bookkeeping.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	70,'Activities of head offices; management consultancy activities', $$This division includes the provision of advice and assistance to businesses and other organizations on management issues, such as strategic and organizational planning; financial planning and budgeting; marketing objectives and policies; human resource policies, practices, and planning; production scheduling; and control planning. It also includes the overseeing and managing of other units of the same company or enterprise, i.e. the activities of head offices.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	71,'Architectural and engineering activities; technical testing and analysis', $$This division includes the provision of architectural services, engineering services, drafting services, building inspection services and surveying and mapping services. It also includes the performance of physical, chemical, and other analytical testing services.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	72,'Scientific research and development', $$This division includes the activities of three types of research and development: 1) basic research: experimental or theoretical work undertaken primarily to acquire new knowledge of the underlying foundations of phenomena and observable facts, without particular application or use in view, 2) applied research: original investigation undertaken in order to acquire new knowledge, directed primarily towards a specific practical aim or objective and 3) experimental development: systematic work, drawing on existing knowledge gained from research and/or practical experience, directed to producing new materials, products and devices, to installing new processes, systems and services, and to improving substantially those already produced or installed. Research and experimental development activities in this division are subdivided into two categories: natural sciences and engineering; social sciences and the humanities. This division excludes market research (see class 7320).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	73,'Advertising and market research', $$This division includes the creation of advertising campaigns and placement of such advertising in periodicals, newspapers, radio and television, or other media as well as the design of display structures and sites.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	74,'Other professional, scientific and technical activities', $$This division includes the provision of professional scientific and technical services (except legal and accounting activities; architecture and engineering activities; technical testing and analysis; management and management consultancy activities; research and development and advertising activities).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	75,'Veterinary activities', $$This division includes the provision of animal health care and control activities for farm animals or pet animals. These activities are carried out by qualified veterinarians in veterinary hospitals as well as when visiting farms, kennels or homes, in own consulting and surgery rooms or elsewhere. It also includes animal ambulance activities.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	77,'Rental and leasing activities', $$This division includes the renting and leasing of tangible and non-financial intangible assets, including a wide array of tangible goods, such as automobiles, computers, consumer goods and industrial machinery and equipment to customers in return for a periodic rental or lease payment. It is subdivided into: (1) the renting of motor vehicles, (2) the renting of recreational and sports equipment and personal and household equipment, (3) the leasing of other machinery and equipment of the kind often used for business operations, including other transport equipment and (4) the leasing of intellectual property products and similar products. Only the provision of operating leases is included in this division. This division excludes financial leasing activities (see class 6491), renting of real estate (see section L) and the renting of equipment with operator. The latter is classified according to the activities carried out with this equipment, e.g. construction (section F) or transportation (section H).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	78,'Employment activities', $$This division includes activities of listing employment vacancies and referring or placing applicants for employment, where the individuals referred or placed are not employees of the employment agencies, supplying workers to clients' businesses for limited periods of time to supplement the working force of the client, and the activities of providing human resources and human resource management services for others on a contract or fee basis. This division also includes executive search and placement activities and activities of theatrical casting agencies. This division excludes the activities of agents for individual artists (see class 7490).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	79,'Travel agency, tour operator, reservation service and related activities', $$This division includes the activity of selling travel, tour, transportation and accommodation services to the general public and commercial clients and the activity of arranging and assembling tours that are sold through travel agencies or directly by agents such as tour operators, as well as other travel-related services including reservation services. The activities of tourist guides and tourism promotion activities are also included.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	80,'Security and investigation activities', $$This division includes security-related services such as: investigation and detective services; guard and patrol services; picking up and delivering money, receipts, or other valuable items with personnel and equipment to protect such properties while in transit; operation of electronic security alarm systems, such as burglar and fire alarms, where the activity focuses on remote monitoring these systems, but often involves also sale, installation and repair services. If the latter components are provided separate, they are excluded from this division and classified in retail sale, construction etc.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	81,'Services to buildings and landscape activities', $$This division includes the provision of a number of general support services, such as the provision of a combination of support services within a client's facilities, the interior and exterior cleaning of buildings of all types, cleaning of industrial machinery, cleaning of trains, buses, planes, etc., cleaning of the inside of road and sea tankers, disinfecting and exterminating activities for buildings, ships, trains, etc., bottle cleaning, street sweeping, snow and ice removal, provision of landscape care and maintenance services and provision of these services along with the design of landscape plans and/or the construction (i.e. installation) of walkways, retaining walls, decks, fences, ponds, and similar structures.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	82,'Office administrative, office support and other business support activities', $$This division includes the provision of a range of day-to-day office administrative services, as well as ongoing routine business support functions for others, on a contract or fee basis. This division also includes all support service activities typically provided to businesses not elsewhere classified. Units classified in this division do not provide operating staff to carry out the complete operations of a business.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	84,'Public administration and defence; compulsory social', $$See section O.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	85,'Education', $$See section P.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	86,'Human health activities', $$This division includes activities of short- or long-term hospitals, general or specialty medical, surgical, psychiatric and substance abuse hospitals, sanatoria, preventoria, medical nursing homes, asylums, mental hospital institutions, rehabilitation centres, leprosaria and other human health institutions which have accommodation facilities and which engage in providing diagnostic and medical treatment to inpatients with any of a wide variety of medical conditions. It also includes medical consultation and treatment in the field of general and specialized medicine by general practitioners and medical specialists and surgeons. It includes dental practice activities of a general or specialized nature and orthodontic activities. Additionally, this division includes activities for human health not performed by hospitals or by practicing medical doctors but by paramedical practitioners legally recognized to treat patients.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	87,'Residential care activities', $$This division includes the provision of residential care combined with either nursing, supervisory or other types of care as required by the residents. Facilities are a significant part of the production process and the care provided is a mix of health and social services with the health services being largely some level of nursing services.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	88,'Social work activities without accommodation', $$This division includes the provision of a variety of social assistance services directly to clients. The activities in this division do not include accommodation services, except on a temporary basis.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	90,'Creative, arts and entertainment activities', $$See class 9000.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	91,'Libraries, archives, museums and other cultural activities', $$This division includes activities of libraries and archives; the operation of museums of all kinds, botanical and zoological gardens; the operation of historical sites and nature reserves activities. It also includes the preservation and exhibition of objects, sites and natural wonders of historical, cultural or educational interest (e.g. world heritage sites, etc). This division excludes sports, amusement and recreation activities, such as the operation of bathing beaches and recreation parks (see division 93).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	92,'Gambling and betting activities', $$This division includes the operation of gambling facilities such as casinos, bingo halls and video gaming terminals and the provision of gambling services, such as lotteries and off-track betting.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	93,'Sports activities and amusement and recreation activities', $$This division includes the provision of recreational, amusement and sports activities (except museums activities, preservation of historical sites, botanical and zoological gardens and nature reserves activities; and gambling and betting activities). Excluded from this division are dramatic arts, music and other arts and entertainment such as the production of live theatrical presentations, concerts and opera or dance productions and other stage productions, see division 90.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	94,'Activities of membership organizations', $$This division includes activities of organizations representing interests of special groups or promoting ideas to the general public. These organizations usually have a constituency of members, but their activities may involve and benefit non-members as well. The primary breakdown of this division is determined by the purpose that these organizations serve, namely interests of employers, self-employed individuals and the scientific community (group 941), interests of employees (group 942) or promotion of religious, political, cultural, educational or recreational ideas and activities (group 949).$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	95,'Repair of computers and personal and household goods', $$This division includes the repair and maintenance of computers peripheral equipment such as desktops, laptops, computer terminals, storage devices and printers. It also includes the repair of communications equipment such as fax machines, two-way radios and consumer electronics such as radios and TVs, home and garden equipment such as lawn-mowers and blowers, footwear and leather goods, furniture and home furnishings, clothing and clothing accessories, sporting goods, musical instruments, hobby articles and other personal and household goods. Excluded from this division is the repair of medical and diagnostic imaging equipment, measuring and surveying instruments, laboratory instruments, radar and sonar equipment, see 3313.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	96,'Other personal service activities', $$This division includes all service activities not mentioned elsewhere in the classification. Notably it includes types of services such as washing and (dry-)cleaning of textiles and fur products, hairdressing and other beauty treatment, funeral and related activities.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	97,'Activities of households as employers of domestic personnel', $$See class 9700.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	98,'Undifferentiated goods- and services-producing activities of private households for own use', $$This division includes the undifferentiated subsistence goods-producing and services-producing activities of households. Households should be classified here only if it is impossible to identify a primary activity for the subsistence activities of the household. If the household engages in market activities, it should be classified according to the primary market activity carried out.$$
);

INSERT INTO "isic_division" (code,name,description) VALUES (
	99,'Activities of extraterritorial organizations and bodies', $$See class 9900.$$
);

--
--
--

INSERT INTO "isic_group" (code,name,description) VALUES (
	011, 'Growing of non-perennial crops',$$This group includes the growing of non-perennial crops, i.e. plants that do not last for more than two growing seasons. Included is the growing of these plants for the purpose of seed production.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	012, 'Growing of perennial crops',$$This group includes the growing of perennial crops, i.e. plants that lasts for more than two growing seasons, either dying back after each season or growing continuously. Included is the growing of these plants for the purpose of seed production.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	013, 'Plant propagation',$$See class 0130.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	014, 'Animal production',$$This group includes raising (farming) and breeding of all animals, except aquatic animals. This group excludes: - breeding support services, such as stud services, see 0162 - farm animal boarding and care, see 0162 - production of hides and skins from slaughterhouses, see 1010$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	015, 'Mixed farming',$$See class 0150.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	016, 'Support activities to agriculture and post-harvest crop activities',$$This group includes activities incidental to agricultural production and activities similar to agriculture not undertaken for production purposes (in the sense of harvesting agricultural products), done on a fee or contract basis. Also included are post-harvest crop activities, aimed at preparing agricultural products for the primary market.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	017, 'Hunting, trapping and related service activities',$$See class 0170.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        021, 'Silviculture and other forestry activities',$$See class 0210.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        022, 'Logging',$$See class 0220.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        023, 'Gathering of non-wood forest products',$$See class 0230.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        024, 'Support services to forestry',$$See class 0240.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        031, 'Fishing', $$This group includes capture fishery, i.e. the hunting, collecting and gathering activities directed at removing or collecting live wild aquatic organisms (predominantly fish, molluscs and crustaceans) including plants from the oceanic, coastal or inland waters for human consumption and other purposes by hand or more usually by various types of fishing gear such as nets, lines and stationary traps. Such activities can be conducted on the intertidal shoreline (e.g. collection of molluscs such as mussels and oysters) or shore based netting, or from home-made dugouts or more commonly using commercially made boats in inshore, coastal waters or offshore waters. Unlike in aquaculture (group 032), the aquatic resource being captured is usually common property resource irrespective of whether the harvest from this resource is undertaken with or without exploitation rights. Such activities also include fishing restocked water bodies.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        032, 'Aquaculture',$$This group includes aquaculture (or aquafarming), i.e. the production process involving the culturing or farming (including harvesting) of aquatic organisms (fish, molluscs, crustaceans, plants, crocodiles, alligators and amphibians) using techniques designed to increase the production of the organisms in question beyond the natural capacity of the environment (for example regular stocking, feeding and protection from predators). Culturing/farming refers to the rearing up to their juvenile and/or adult phase under captive conditions of the above organisms. In addition, aquaculture also encompasses individual, corporate or state ownership of the individual organisms throughout the rearing or culture stage, up to and including harvesting.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        051, 'Mining of hard coal',$$See class 0510.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        052, 'Mining of lignite',$$See class 0520.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        061, 'Extraction of crude petroleum', $$See class 0610.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        062, 'Extraction of natural gas',$$See class 0620.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        071, 'Mining of iron ores',$$See class 0710.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        072, 'Mining of non-ferrous metal ores',$$This group includes the mining of non-ferrous metal ores.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        081, 'Quarrying of stone, sand and clay',$$See class 0810.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        089, 'Mining and quarrying n.e.c.',$$No explanatory note available for this code.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        091, 'Support activities for petroleum and natural gas extraction',$$See class 0910.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        099 'Support activities for other mining and quarrying',$$See class 0990.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
         101, 'Processing and preserving of meat',$$See class 1010.$$ 
)

INSERT INTO "isic_group" (code,name,description) VALUES (
        102, 'Processing and preserving of fish, crustaceans and molluscs',$$See class 1020.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        103, 'Processing and preserving of fruit and vegetables',$$See class 1030.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        104, 'Manufacture of vegetable and animal oils and fats',$$See class 1040.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        105, 'Manufacture of dairy products',$$See class 1050.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        106, 'Manufacture of grain mill products, starches and starch products',$$This group includes the milling of flour or meal from grains or vegetables, the milling, cleaning and polishing of rice, as well as the manufacture of flour mixes or doughs from these products. Also included in this group are the wet milling of corn and vegetables and the manufacture of starch and starch products.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        107, 'Manufacture of other food products',$$This group includes the production of a variety of food products not included in previous groups of this division. This includes the production of bakery products, sugar and confectionery, macaroni, noodles and similar products, prepared meals and dishes, coffee, tea and spices, as well as perishable and specialty food products.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        108, 'Manufacture of prepared animal feeds',$$See class 1080.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        110, 'Manufacture of beverages',$$See division 11.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        120, 'Manufacture of tobacco products',$$See class 1200.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        131, 'Spinning, weaving and finishing of textiles',$$This group includes the manufacture of textiles, including preparatory operations, the spinning of textile fibres and the weaving of textiles. This can be done from varying raw materials, such as silk, wool, other animal, vegetable or man-made fibres, paper or glass etc. Also included in this group is the finishing of textiles and wearing apparel, i.e. bleaching, dyeing, dressing and similar activities.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        139 , 'Manufacture of other textiles',$$This group includes the manufacture of products produced from textiles, except wearing apparel, such as made-up textile articles, carpets and rugs, rope, narrow woven fabrics, trimmings etc.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        141, 'Manufacture of wearing apparel, except fur apparel',$$See class 1410.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        142, 'Manufacture of articles of fur',$$See class 1420.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        143, 'Manufacture of knitted and crocheted apparel',$$See class 1430.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        151, 'Tanning and dressing of leather; manufacture of luggage, handbags, saddlery and harness; dressing and dyeing of fur',$$This group includes the manufacture of leather and fur and products thereof.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        152, 'Manufacture of footwear',$$See class 1520.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        161, 'Sawmilling and planing of wood',$$See class 1610.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        162, 'Manufacture of products of wood, cork, straw and plaiting materials',$$This group includes the manufacture of products of wood, cork, straw or plaiting materials, including basic shapes as well as assembled products.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        170, 'Manufacture of paper and paper products',$$See division 17.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        181, 'Printing and service activities related to printing',$$This group includes printing of products, such as newspapers, books, periodicals, business forms, greeting cards, and other materials, and associated support activities, such as bookbinding, plate-making services, and data imaging. Printing can be done using various techniques and on different materials.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        182, 'Reproduction of recorded media',$$See class 1820.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        191, 'Manufacture of coke oven products',$$See class 1910.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        192, 'Manufacture of refined petroleum products',$$See class 1920.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        201, 'Manufacture of basic chemicals, fertilizers and nitrogen compounds, plastics and synthetic rubber in primary forms',$$This group includes the manufacture of basic chemical products, fertilizers and associated nitrogen compounds, as well as plastics and synthetic rubber in primary forms.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        202, 'Manufacture of other chemical products',$$This group includes the manufacture of chemical products other than basic chemicals and man-made fibres. This includes the manufacture of a variety of goods such as pesticides, paints and inks, soap, cleaning preparations, perfumes and toilet preparations, explosives and pyrotechnic products, chemical preparations for photographic uses (including film and sensitized paper), gelatins, composite diagnostic preparations etc.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        203, 'Manufacture of man-made fibres',$$See class 2030.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        210, 'Manufacture of pharmaceuticals, medicinal chemical and botanical products',$$See class 2100.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        221, 'Manufacture of rubber products',$$This group includes the manufacture of rubber products.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        222, 'Manufacture of plastics products',$$See class 2220.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        231, 'Manufacture of glass and glass products',$$See class 2310.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        239, 'Manufacture of non-metallic mineral products n.e.c.',$$This group includes the manufacture of intermediate and final products from mined or quarried non-metallic minerals, such as sand, gravel, stone or clay.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        241, 'Manufacture of basic iron and steel',$$See class 2410.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        242, 'Manufacture of basic precious and other non-ferrous metals',$$See class 2420.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        243, 'Casting of metals',$$This group includes the manufacture of semi-finished products and various castings by a casting process. This group excludes: - manufacture of finished cast products such as: - boilers and radiators, see 2512 - cast household items, see 2599$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        251, 'Manufacture of structural metal products, tanks, reservoirs and steam generators',$$This group includes the manufacture of structural metal products (such as metal frameworks or parts for construction), as well as metal container-type objects (such as reservoirs, tanks, central heating boilers) and steam generators.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        252, 'Manufacture of weapons and ammunition',$$See class 2520.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        259, 'Manufacture of other fabricated metal products; metalworking service activities',$$This group includes general activities for the treatment of metal, such as forging or pressing, plating, coating, engraving, boring, polishing, welding etc., which are typically carried out on a fee or contract basis. This group also includes the manufacture of a variety of metal products, such as cutlery; metal hand tools and general hardware; cans and buckets; nails, bolts and nuts; metal household articles; metal fixtures; ships propellers and anchors; assembled railway track fixtures etc. for a variety of household and industrial uses.$$

INSERT INTO "isic_group" (code,name,description) VALUES (
        261, 'Manufacture of electronic components and boards',$$See class 2610.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        262, 'Manufacture of computers and peripheral equipment',$$See class 2620.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        263, 'Manufacture of communication equipment',$$See class 2630.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        264, 'Manufacture of consumer electronics',$$See class 2640.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        265, 'Manufacture of measuring, testing, navigating and control equipment; watches and clocks',$$This group includes the manufacture of measuring, testing, navigating and control equipment for various industrial and non-industrial purposes, including time-based measuring devices such as watches and clocks and related devices.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        266, 'Manufacture of irradiation, electromedical and electrotherapeutic equipment',$$See class 2660.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        267, 'Manufacture of optical instruments and photographic equipment',$$See class 2670.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        268, 'Manufacture of magnetic and optical media',$$See class 2680.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        271, 'Manufacture of electric motors, generators, transformers and electricity distribution and control apparatus',$$See class 2710.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        272, 'Manufacture of batteries and accumulators',$$See class 2720.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        273, 'Manufacture of wiring and wiring devices',$$This group includes the manufacture of current-carrying wiring devices and non current-carrying wiring devices for wiring electrical circuits regardless of material. This group also includes the insulating of wire and the manufacture of fiber optic cables.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        274, 'Manufacture of electric lighting equipment',$$See class 2740.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        275, 'Manufacture of domestic appliances',$$See class 2750.$$ 
);
INSERT INTO "isic_group" (code,name,description) VALUES (
        279, 'Manufacture of other electrical equipment',$$See class 2790.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        281, 'Manufacture of general-purpose machinery',$$This group includes the manufacture of general-purpose machinery, i.e. machinery that is being used in a wide range of ISIC industries. This can include the manufacture of components used in the manufacture of a variety of other machinery or the manufacture of machinery that support the operation of other businesses.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        282, 'Manufacture of special-purpose machinery',$$This group includes the manufacture of special-purpose machinery, i.e. machinery for exclusive use in an ISIC industry or a small cluster of ISIC industries. While most of these are used in other manufacturing processes, such as food manufacturing or textile manufacturing, this group also includes the manufacture of machinery specific for other (non-manufacturing industries), such as aircraft launching gear or amusement park equipment.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        291, 'Manufacture of motor vehicles',$$See class 2910.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        292, 'Manufacture of bodies (coachwork) for motor vehicles; manufacture of trailers and semi-trailers',$$See class 2920.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        293, 'Manufacture of parts and accessories for motor vehicles',$$See class 2930.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        301, 'Building of ships and boats',$$This group includes the building of ships, boats and other floating structures for transportation and other commercial purposes, as well as for sports and recreational purposes.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        302, 'Manufacture of railway locomotives and rolling stock',$$See class 3020.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        303, 'Manufacture of air and spacecraft and related machinery',$$See class 3030.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        304, 'Manufacture of military fighting vehicles',$$See class 3040.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        309, 'Manufacture of transport equipment n.e.c.',$$This group includes the manufacture of transport equipment other than motor vehicles and rail, water, air or space transport equipment and military vehicles.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        310, 'Manufacture of furniture',$$See class 3100.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        321, 'Manufacture of jewellery, bijouterie and related articles',$$This group includes the manufacture of jewellery and imitation jewellery articles.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        322, 'Manufacture of musical instruments',$$See class 3220.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        323, 'Manufacture of sports goods',$$See class 3230.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        324, 'Manufacture of games and toys',$$See class 3240.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        325, 'Manufacture of medical and dental instruments and supplies',$$See class 3250.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        329, 'Other manufacturing n.e.c.',$$See class 3290.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        331, 'Repair of fabricated metal products, machinery and equipment',$$This group includes the specialized repair of goods produced in the manufacturing sector with the aim to restore these metal products, machinery, equipment and other products to working order. The provision of general or routine maintenance (i.e. servicing) on such products to ensure they work efficiently and to prevent breakdown and unnecessary repairs is included. This group excludes: - rebuilding or remanufacturing of machinery and equipment, see corresponding class in divisions 25-31 - cleaning of industrial machinery, see 8129 - repair and maintenance of computers and communications equipment, see group 951 - repair and maintenance of household goods, see group 952$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        332, 'Installation of industrial machinery and equipment',$$See class 3320.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        351, 'Electric power generation, transmission and distribution',$$See class 3510.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        352, 'Manufacture of gas; distribution of gaseous fuels through mains',$$See class 3520.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        353, 'Steam and air conditioning supply',$$See class 3530.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        360, 'Water collection, treatment and supply',$$See class 3600.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        370, 'Sewerage',$$See class 3700.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        381, 'Waste collection',$$This group includes the collection of waste from households and businesses by means of refuse bins, wheeled bins, containers, etc. It includes collection of non-hazardous and hazardous waste e.g. waste from households, used batteries, used cooking oils and fats, waste oil from ships and used oil from garages, as well as construction and demolition waste.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        382, 'Waste treatment and disposal',$$This group includes the disposal and treatment prior to disposal of various forms of waste by different means, such as waste treatment of organic waste with the aim of disposal; treatment and disposal of toxic live or dead animals and other contaminated waste; treatment and disposal of transition radioactive waste from hospitals, etc.; dumping of refuse on land or in water; burial or ploughing-under of refuse; disposal of used goods such as refrigerators to eliminate harmful waste; disposal of waste by incineration or combustion. Included is also the generation of electricity resulting from waste incineration processes. This group excludes: - treatment and disposal of wastewater, see 3700$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        383, 'Materials recovery',$$See class 3830.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        390, 'Remediation activities and other waste management services',$$See class 3900.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        410, 'Construction of buildings',$$See class 4100.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        421, 'Construction of roads and railways',$$See class 4210.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        422, 'Construction of utility projects',$$See class 4220.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        429, 'Construction of other civil engineering projects',$$See class 4290.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        431, 'Demolition and site preparation',$$This group includes activities of preparing a site for subsequent construction activities, including the removal of previously existing structures.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        432, 'Electrical, plumbing and other construction installation activities',$$This group includes installation activities that support the functioning of a building as such, including installation of electrical systems, plumbing (water, gas and sewage systems), heat and air-conditioning systems, elevators etc.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        433, 'Building completion and finishing',$$See class 4330.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        439, 'Other specialized construction activities',$$See class 4390.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        451, 'Sale of motor vehicles',$$See class 4510.$$ 
);
INSERT INTO "isic_group" (code,name,description) VALUES (
        452, 'Maintenance and repair of motor vehicles',$$See class 4520.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        453, 'Sale of motor vehicle parts and accessories',$$See class 4530.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        454, 'Sale, maintenance and repair of motorcycles and related parts and accessories',$$See class 4540.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        461, 'Wholesale on a fee or contract basis',$$See class 4610.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        462, 'Wholesale of agricultural raw materials and live animals',$$See class 4620.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        463, 'Wholesale of food, beverages and tobacco',$$See class 4630.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        464, 'Wholesale of household goods',$$This group includes the wholesale of household goods, including textiles.$$ 
);
INSERT INTO "isic_group" (code,name,description) VALUES (
        465, 'Wholesale of machinery, equipment and supplies',$$This group includes the wholesale of computers, telecommunications equipment, specialized machinery for all kinds of industries and general-purpose machinery.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        466, 'Other specialized wholesale',$$This group includes other specialized wholesale activities not classified in other groups of this division. This includes the wholesale of intermediate products, except agricultural, typically not for household use.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        469, 'Non-specialized wholesale trade',$$See class 4690.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        471, 'Retail sale in non-specialized stores',$$This group includes the retail sale of a variety of product lines in the same unit (non-specialized stores), such as supermarkets or department stores.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        472, 'Retail sale of food, beverages and tobacco in specialized stores',$$This group includes retail sale in stores specialized in selling food, beverage or tobacco products.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        473, 'Retail sale of automotive fuel in specialized stores',$$See class 4730.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        474, 'Retail sale of information and communications equipment in specialized stores',$$This group includes the retail sale of information and communications equipment, such as computers and peripheral equipment, telecommunications equipment and consumer electronics, by specialized stores.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        475, 'Retail sale of other household equipment in specialized stores',$$This group includes the retail sale of household equipment, such as textiles, hardware, carpets, electrical appliances or furniture, in specialized stores.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        476, 'Retail sale of cultural and recreation goods in specialized stores',$$This group includes the retail sale in specialized stores of cultural and recreation goods, such as books, newspapers, music and video recordings, sporting equipment, games and toys.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        477, 'Retail sale of other goods in specialized stores',$$This group includes the sale in specialized stores carrying a particular line of products not included in other parts of the classification, such as clothing, footwear and leather articles, pharmaceutical and medical goods, watches, souvenirs, cleaning materials, weapons, flowers and pets and others. Also included is the retail sale of used goods in specialized stores.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        478, 'Retail sale via stalls and markets',$$This group includes the retail sale of any kind of new or second hand product in a usually movable stall either along a public road or at a fixed marketplace.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        479, 'Retail trade not in stores, stalls or markets',$$This group includes retail sale activities by mail order houses, over the Internet, through door-to-door sales, vending machines etc.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        491, 'Transport via railways',$$This group includes rail transportation of passengers and/or freight using railroad rolling stock on mainline networks, usually spread over an extensive geographic area. Freight rail transport over short-line freight railroads is included here. This group excludes: - urban and suburban passenger land transport, see 4921 - related activities such as switching and shunting, see 5221 - operation of railroad infrastructure, see 5221$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        492, 'Other land transport',$$This group includes all land-based transport activities other than rail transport. However, rail transport as part of urban or suburban transport systems is included here.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        493, 'Transport via pipeline',$$See class 4930.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        501, 'Sea and coastal water transport',$$This group includes the transport of passengers or freight on vessels designed for operating on sea or coastal waters. Also included is the transport of passengers or freight on great lakes etc. when similar types of vessels are used.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        502, 'Inland water transport',$$This group includes the transport of passengers or freight on inland waters, involving vessels that are not suitable for sea transport.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        511, 'Passenger air transport',$$See class 5110.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        512, 'Freight air transport',$$See class 5120.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        521, 'Warehousing and storage',$$See class 5210.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        522, 'Support activities for transportation',$$This group includes activities supporting the transport of passengers or freight, such as operation of parts of the transport infrastructure or activities related to handling freight immediately before or after transport or between transport segments. The operation and maintenance of all transport facilities is included.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        531, 'Postal activities',$$See class 5310.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        532, 'Courier activities',$$See class 5320.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        551, 'Short term accommodation activities',$$See class 5510.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        552, 'Camping grounds, recreational vehicle parks and trailer parks',$$See class 5520.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        559, 'Other accommodation',$$See class 5590.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        561, 'Restaurants and mobile food service activities',$$See class 5610.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        562, 'Event catering and other food service activities',$$This group includes catering activities for individual events or for a specified period of time and the operation of food concessions, such as at sports or similar facilities.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        563, 'Beverage serving activities',$$See class 5630.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        581, 'Publishing of books, periodicals and other publishing activities',$$This group includes activities of publishing books, newspapers, magazines and other periodicals, directories and mailing lists, and other works such as photos, engravings, postcards, timetables, forms, posters and reproductions of works of art. These works are characterized by the intellectual creativity required in their development and are usually protected by copyright.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        582, 'Software publishing',$$See class 5820.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        591, 'Motion picture, video and television programme activities',$$This group includes production of theatrical and non-theatrical motion pictures whether on film, videotape, DVD or other media, including digital distribution, for direct projection in theatres or for broadcasting on television; supporting activities such as film editing, cutting, dubbing etc.; distribution of motion pictures or other film productions (video tapes, DVDs, etc) to other industries; as well as their projection. Buying and selling of motion picture or any other film production distribution rights is also included.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        592, 'Sound recording and music publishing activities',$$See class 5920.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
	601, 'Radio broadcasting',$$See class 6010.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        602, 'Television programming and broadcasting activities',$$See class 6020.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        611, 'Wired telecommunications activities',$$See class 6110.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        612, 'Wireless telecommunications activities',$$See class 6120.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        613, 'Satellite telecommunications activities',$$See class 6130.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        619, 'Other telecommunications activities',$$See class 6190.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        620, 'Computer programming, consultancy and related activities',$$This division includes the following activities of providing expertise in the field of information technologies: writing, modifying, testing and supporting software; planning and designing computer systems that integrate computer hardware, software and communication technologies; on-site management and operation of clients' computer systems and/or data processing facilities; and other professional and technical computer-related activities.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        631, 'Data processing, hosting and related activities; web portals',$$This group includes the provision of infrastructure for hosting, data processing services and related activities, as well as the provision of search facilities and other portals for the Internet.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        639, 'Other information service activities',$$This group includes the activities of news agencies and all other remaining information service activities. This group excludes: - activities of libraries and archives, see 9101$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        641, 'Monetary intermediation',$$This group includes the obtaining of funds in the form of transferable deposits, i.e. funds that are fixed in money terms, obtained on a day-to-day basis and, apart from central banking, obtained from non-financial sources.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        642, 'Activities of holding companies',$$See class 6420.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        643, 'Trusts, funds and similar financial entities',$$See class 6430.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        649, 'Other financial service activities, except insurance and pension funding activities',$$This group includes financial service activities other than those conducted by monetary institutions. This group excludes: - insurance and pension funding activities, see division 65$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        651, 'Insurance',$$This group includes life insurance and life reinsurance with or without a substantial savings element and other non-life insurance.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        652, 'Reinsurance',$$See class 6520.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        653, 'Pension funding',$$See class 6530.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        661, 'Activities auxiliary to financial service activities, except insurance and pension funding',$$This group includes the furnishing of physical or electronic marketplaces for the purpose of facilitating the buying and selling of stocks, stock options, bonds or commodity contracts.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        662, 'Activities auxiliary to insurance and pension funding',$$This group includes acting as agent (i.e. broker) in selling annuities and insurance policies or providing other employee benefits and insurance and pension related services such as claims adjustment and third party administration.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        663, 'Fund management activities',$$See class 6630.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        681, 'Real estate activities with own or leased property',$$See class 6810.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        682, 'Real estate activities on a fee or contract basis',$$See class 6820.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        691, 'Legal activities',$$See class 6910.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        692, 'Accounting, bookkeeping and auditing activities; tax consultancy',$$See class 6920.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        701, 'Activities of head offices',$$See class 7010.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        702, 'Management consultancy activities',$$See class 7020.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        711, 'Architectural and engineering activities and related technical consultancy',$$See class 7110.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        712, 'Technical testing and analysis',$$See class 7120.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        721, 'Research and experimental development on natural sciences and engineering',$$See class 7210.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        722, 'Research and experimental development on social sciences and humanities',$$See class 7220.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        731, 'Advertising',$$See class 7310.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        732, 'Market research and public opinion polling',$$See class 7320.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        741, 'Specialized design activities',$$See class 7410.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        742, 'Photographic activities',$$See class 7420.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        749, 'Other professional, scientific and technical activities n.e.c.',$$See class 7490.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        750, 'Veterinary activities',$$See class 7500.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        771, 'Renting and leasing of motor vehicles',$$See class 7710.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        772, 'Renting and leasing of personal and household goods',$$This group includes the renting of personal and household goods as well as renting of recreational and sports equipment and video tapes. Activities generally include short-term renting of goods although in some instances, the goods may be leased for longer periods of time.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        773, 'Renting and leasing of other machinery, equipment and tangible goods',$$See class 7730.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        774, 'Leasing of intellectual property and similar products, except copyrighted works',$$See class 7740.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        781, 'Activities of employment placement agencies',$$See class 7810.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        782, 'Temporary employment agency activities',$$See class 7820.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        783, 'Other human resources provision',$$See class 7830.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        791, 'Travel agency and tour operator activities',$$This group includes the activities of agencies, primarily engaged in selling travel, tour, transportation and accommodation services to the general public and commercial clients and the activity of arranging and assembling tours that are sold through travel agencies or directly by agents such as tour operators.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        799, 'Other reservation service and related activities',$$See class 7990.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        801, 'Private security activities',$$See class 8010.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        802, 'Security systems service activities',$$See class 8020.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        803, 'Investigation activities',$$See class 8030.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        811, 'Combined facilities support activities',$$See class 8110.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        812, 'Cleaning activities',$$This group includes the activities of general interior cleaning of all types of buildings, exterior cleaning of buildings, specialized cleaning activities for buildings or other specialized cleaning activities, cleaning of industrial machinery, cleaning of the inside of road and sea tankers, disinfecting and extermination activities for buildings and industrial machinery, bottle cleaning, street sweeping, snow and ice removal. This group excludes: - agricultural pest control, see 0161 - cleaning of new buildings immediately after construction, 4330 - steam-cleaning, sand blasting and similar activities for building exteriors, see 4390 - carpet and rug shampooing, drapery and curtain cleaning, see 9601$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        813, 'Landscape care and maintenance service activities',$$See class 8130.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        821, 'Office administrative and support activities',$$This group includes the provision of a range of day-to-day office administrative services, such as financial planning, billing and record keeping, personnel and physical distribution and logistics for others on a contract or fee basis. This group includes also support activities for others on a contract or fee basis, that are ongoing routine business support functions that businesses and organizations traditionally do for themselves. Units classified in this group do not provide operating staff to carry out the complete operations of a business. Units engaged in one particular aspect of these activities are classified according to that particular activity.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        822, 'Activities of call centres',$$See class 8220.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        823, 'Organization of conventions and trade shows',$$See class 8230.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        829, 'Business support service activities n.e.c.',$$This group includes the activities of collection agencies, credit bureaus and all support activities typically provided to businesses not elsewhere classified.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        841, 'Administration of the State and the economic and social policy of the community',$$This group includes general administration (e.g. executive, legislative, financial administration etc. at all levels of government) and supervision in the field of social and economic life.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        842, 'Provision of services to the community as a whole',$$This group includes foreign affairs, defence and public order and safety activities.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        843, 'Compulsory social security activities',$$See class 8430.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        851, 'Pre-primary and primary education',$$See class 8510.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        852, 'Secondary education',$$This group includes the provision of general secondary and technical and vocational secondary education.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        853, 'Higher education',$$See class 8530.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        854, 'Other education',$$This group includes general continuing education and continuing vocational education and training for any profession. Instruction may be oral or written and may be provided in classrooms or by radio, television, Internet, correspondence or other means of communication. This group also includes the provision of instruction in athletic activities to groups or individuals, foreign language instruction, instruction in the arts, drama or music or other instruction or specialized training, not comparable to the education in groups 851 - 853. This group excludes: - provision of primary education, secondary education or higher education, see groups 851, 852, 853$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        855, 'Educational support activities',$$See class 8550.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        861, 'Hospital activities',$$See class 8610.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        862, 'Medical and dental practice activities',$$See class 8620.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        869, 'Other human health activities',$$See class 8690.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        871, 'Residential nursing care facilities',$$See class 8710.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        872, 'Residential care activities for mental retardation, mental health and substance abuse',$$See class 8720.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        873, 'Residential care activities for the elderly and disabled',$$See class 8730.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        879, 'Other residential care activities',$$See class 8790.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        881, 'Social work activities without accommodation for the elderly and disabled',$$See class 8810.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        889, 'Other social work activities without accommodation',$$See class 8890.$$
);


INSERT INTO "isic_group" (code,name,description) VALUES (
        900, 'Creative, arts and entertainment activities',$$See class 9000.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        910, 'Libraries, archives, museums and other cultural activities',$$See division 91.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        920, 'Gambling and betting activities',$$See class 9200.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        931, 'Sports activities',$$This group includes the operation of sports facilities; activities of sports teams or clubs primarily participating in live sports events before a paying audience; independent athletes engaged in participating in live sporting or racing events before a paying audience; owners of racing participants such as cars, dogs, horses, etc. primarily engaged in entering them in racing events or other spectator sports events; sports trainers providing specialized services to support participants in sports events or competitions; operators of arenas and stadiums; other activities of organizing, promoting or managing sports events, n.e.c.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        932, 'Other amusement and recreation activities',$$This group includes the activities of a wide range of units that operate facilities or provide services to meet the varied recreational interests of their patrons, including the operation of a variety of attractions, such as mechanical rides, water rides, games, shows, theme exhibits and picnic grounds. This group excludes: - sports activities, see group 931 - dramatic arts, music and other arts and entertainment activities, see 9000$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        941, 'Activities of business, employers and professional membership organizations',$$This group includes the activities of units that promote the interests of the members of business and employers organizations. In the case of professional membership organizations, it also includes the activities of promoting the professional interests of members of the profession.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        942, 'Activities of trade unions',$$See class 9420.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        949, 'Activities of other membership organizations',$$This group includes the activities of units (except business and employers organizations, professional organizations, trade unions) that promote the interests of their members.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        951, 'Repair of computers and communication equipment',$$This group includes the repair and maintenance of computers and peripheral equipment and communications equipment.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        952 , 'Repair of personal and household goods',$$This group includes the repair and servicing of personal and household goods.$$
);
INSERT INTO "isic_group" (code,name,description) VALUES (
        960, 'Other personal service activities',$$See division 96.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        970, 'Activities of households as employers of domestic personnel',$$See class 9700.$$
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        981, 'Undifferentiated goods-producing activities of private households for own use',$$See class 9810.$$ 
);

INSERT INTO "isic_group" (code,name,description) VALUES (
        982, 'Undifferentiated service-producing activities of private households for own use',$$See class 9820.$$
);
INSERT INTO "isic_group" (code,name,description) VALUES (
        990, 'Activities of extraterritorial organizations and bodies',$$See class 9900.$$
);

--
--
--


INSERT INTO "isic_class" (code,name,description) VALUES ( 
		0111,'Growing of cereals (except rice), leguminous crops and oil seeds', $$This class includes all forms of growing of cereals, leguminous crops and oil seeds in open fields, including those considered organic farming and the growing of genetically modified crops. The growing of these crops is often combined within agricultural units. This class includes: - growing of cereals such as: - wheat - grain maize - sorghum - barley - rye - oats - millets - other cereals n.e.c. - growing of leguminous crops such as: - beans - broad beans - chick peas - cow peas - lentils - lupins - peas - pigeon peas - other leguminous crops - growing of oil seeds such as: - soya beans - groundnuts - castor bean - linseed - mustard seed - niger seed - rapeseed - safflower seed - sesame seed - sunflower seed - other oil seeds This class excludes: - growing of maize for fodder, see 0119$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0112,'Growing of rice', $$This class includes: - growing of rice (including organic farming and the growing of genetically modified rice)$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0113,'Growing of vegetables and melons, roots and tubers', $$This class includes: - growing of leafy or stem vegetables such as: - artichokes - asparagus - cabbages - cauliflower and broccoli - lettuce and chicory - spinach - other leafy or stem vegetables - growing of fruit bearing vegetables such as: - cucumbers and gherkins - eggplants (aubergines) - tomatoes - watermelons - cantaloupes - other melons and fruit-bearing vegetables - growing of root, bulb or tuberous vegetables such as: - carrots - turnips - garlic - onions (incl. shallots) - leeks and other alliaceous vegetables - other root, bulb or tuberous vegetables - growing of mushrooms and truffles - growing of vegetable seeds, except beet seeds - growing of sugar beet - growing of other vegetables - growing of roots and tubers such as: - potatoes - sweet potatoes - cassava - yams - other roots and tubers This class excludes: - growing of mushroom spawn, see 0130 - growing of chilies and peppers (capsicum spp.) and other spices and aromatic crops, see 0128$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0114,'Growing of sugar cane', $$This class includes: - growing of sugar cane This class excludes: - growing of sugar beet, see 0113$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0115,'Growing of tobacco', $$This class includes: - growing of unmanufactured tobacco$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0116,'Growing of fibre crops', $$This class includes: - growing of cotton - growing of jute, kenaf and other textile bast fibres - growing of flax and true hemp - growing of sisal and other textile fibre of the genus agave - growing of abaca, ramie and other vegetable textile fibres - growing of other fibre crops$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0119,'Growing of other non-perennial crops', $$This class includes the growing of non-perennial crops not elsewhere classified. This class includes: - growing of swedes, mangolds, fodder roots, clover, alfalfa, sainfoin, maize and other grasses, forage kale and similar forage products - growing of beet seeds (excluding sugar beet seeds) and seeds of forage plants - growing of flowers, including production of cut flowers and flower buds - growing of flower seeds This class excludes: - growing of sunflower seeds, see 0111 - growing of non-perennial spice, aromatic, drug and pharmaceutical crops, see 0128$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0121,'Growing of grapes', $$This class includes: - growing of wine grapes and table grapes in vineyards This class excludes: - manufacture of wine, see 1102$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0122,'Growing of tropical and subtropical fruits', $$This class includes: - growing of tropical and subtropical fruits: - avocados - bananas and plantains - dates - figs - mangoes - papayas - pineapples - other tropical and subtropical fruits$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0123,'Growing of citrus fruits', $$This class includes: - growing of citrus fruits: - grapefruit and pomelo - lemons and limes - oranges - tangerines, mandarins and clementines - other citrus fruits$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0124,'Growing of pome fruits and stone fruits', $$This class includes: - growing of pome fruits and stone fruits: - apples - apricots - cherries and sour cherries - peaches and nectarines - pears and quinces - plums and sloes - other pome fruits and stone fruits$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0125,'Growing of other tree and bush fruits and nuts', $$This class includes: - growing of berries: - blueberries - currants - gooseberries - kiwi fruit - raspberries - strawberries - other berries - growing of fruit seeds - growing of edible nuts: - almonds - cashew nuts - chestnuts - hazelnuts - pistachios - walnuts - other nuts - growing of other tree and bush fruits: - locust beans This class excludes: - growing of coconuts, see 0126$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0126,'Growing of oleaginous fruits', $$This class includes: - growing of oleaginous fruits: - coconuts - olives - oil palms - other oleaginous fruits This class excludes: - growing of soya beans, groundnuts and other oil seeds, see 0111$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0127,'Growing of beverage crops', $$This class includes: - growing of beverage crops: - coffee - tea - maté - cocoa - other beverage crops$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0128,'Growing of spices, aromatic, drug and pharmaceutical crops', $$This class includes: - growing of perennial and non-perennial spices and aromatic crops: - pepper (piper spp.) - chilies and peppers (capsicum spp.) - nutmeg, mace and cardamoms - anise, badian and fennel - cinnamon (canella) - cloves - ginger - vanilla - hops - other spices and aromatic crops - growing of drug and narcotic crops - growing of plants used primarily in perfumery, in pharmacy or for insecticidal, fungicidal or similar purposes$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0129,'Growing of other perennial crops', $$This class includes: - growing of rubber trees - growing of Christmas trees - growing of trees for extraction of sap - growing of vegetable materials of a kind used primarily for plaiting This class excludes: - gathering of tree sap or rubber-like gums in the wild, see 0230$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0130, 'Plant propagation', $$This class includes the production of all vegetative planting materials including cuttings, suckers and seedlings for direct plant propagation or to create plant grafting stock into which selected scion is grafted for eventual planting to produce crops. This class includes: - growing of plants for planting - growing of plants for ornamental purposes, including turf for transplanting - growing of live plants for bulbs, tubers and roots; cuttings and slips; mushroom spawn - operation of tree nurseries, except forest tree nurseries This class excludes: - growing of plants for the purpose of seed production, see groups 011 and 012 - operation of forest tree nurseries, see 0210$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0141, 'Raising of cattle and buffaloes', $$This class includes: - raising and breeding of cattle and buffaloes - production of raw cow milk from cows or buffaloes - production of bovine semen This class excludes: - processing of milk, see 1050$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0142, 'Raising of horses and other equines', $$This class includes: - raising and breeding of horses (including racing horses), asses, mules or hinnies This class excludes: - operation of racing and riding stables, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0143, 'Raising of camels and camelids', $$This class includes: - raising and breeding of camels (dromedary) and camelids$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0144, 'Raising of sheep and goats', $$This class includes: - raising and breeding of sheep and goats - production of raw sheep or goat milk - production of raw wool This class excludes: - sheep shearing on a fee or contract basis, see 0162 - production of pulled wool, see 1010 - processing of milk, see 1050$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0145, 'Raising of swine/pigs', $$This class includes: - raising and breeding of swine (pigs)$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0146, 'Raising of poultry', $$This class includes: - raising and breeding of poultry: - fowls of the species Gallus domesticus (chickens and capons), ducks, geese, turkeys and guinea fowls - production of eggs - operation of poultry hatcheries This class excludes: - production of feathers or down, see 1010$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0149, 'Raising of other animals', $$This class includes: - raising and breeding of semi-domesticated or other live animals: - ostriches and emus - other birds (except poultry) - insects - rabbits and other fur animals - production of fur skins, reptile or bird skins from ranching operation - operation of worm farms, land mollusc farms, snail farms etc. - raising of silk worms, production of silk worm cocoons - bee-keeping and production of honey and beeswax - raising and breeding of pet animals (except fish): - cats and dogs - birds, such as parakeets etc. - hamsters etc. - raising of diverse animals This class excludes: - production of hides and skins originating from hunting and trapping, see 0170 - operation of frog farms, crocodile farms, marine worm farms, see 0321, 0322 - operation of fish farms, see 0321, 0322 - training of pet animals, see 9609$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0150, 'Mixed farming', $$This class includes the combined production of crops and animals without a specialized production of crops or animals. The size of the overall farming operation is not a determining factor. If either production of crops or animals in a given unit exceeds 66 per cent or more of standard gross margins, the combined activity should not be included here, but allocated to crop or animal farming. This class excludes: - mixed crop farming, see groups 011 and 012 - mixed animal farming, see group 014$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0161, 'Support activities for crop production', $$This class includes: - agricultural activities on a fee or contract basis: - preparation of fields - establishing a crop - treatment of crops - crop spraying, including by air - trimming of fruit trees and vines - transplanting of rice, thinning of beets - harvesting - pest control (including rabbits) in connection with agriculture - operation of agricultural irrigation equipment This class also includes: - provision of agricultural machinery with operators and crew - maintenance of land to keep it in good condition for agricultural use This class excludes: - post-harvest crop activities, see 0163 - activities of agronomists and agricultural economists, see 7490 - landscape architecture, see 7110 - landscape gardening, planting, see 8130 - maintenance of land to keep it in good ecological condition, see 8130 - organization of agricultural shows and fairs, see 8230$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0162, 'Support activities for animal production', $$This class includes: - agricultural activities on a fee or contract basis: - activities to promote propagation, growth and output of animals - herd testing services, droving services, agistment services, poultry caponizing, coop cleaning etc. - activities related to artificial insemination - stud services - sheep shearing - farm animal boarding and care This class also includes: - activities of farriers This class excludes: - provision of space for animal boarding only, see 6810 - veterinary activities, see 7500 - vaccination of animals, see 7500 - renting of animals (e.g. herds), see 7730 - service activities to promote commercial hunting and trapping, see 9499 - pet boarding, see 9609$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0163, 'Post-harvest crop activities', $$This class includes: - preparation of crops for primary markets, i.e. cleaning, trimming, grading, disinfecting - cotton ginning - preparation of tobacco leaves - preparation of cocoa beans - waxing of fruit - sun-drying of fruit and vegetables This class excludes: - preparation of agricultural products by the producer, see groups 011 and 012 - preserving of fruit and vegetables, including dehydration by artificial means, see 1030 - stemming and redrying of tobacco, see 1200 - marketing activities of commission merchants and cooperative associations, see division 46 - wholesale of agricultural raw materials, see 4620$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0164, 'Seed processing for propagation', $$This class includes all post-harvest activities aimed at improving the propagation quality of seed through the removal of non-seed materials, undersized, mechanically or insect-damaged and immature seeds as well as removing the seed moisture to a safe level for seed storage. This activity includes the drying, cleaning, grading and treating of seeds until they are marketed. The treatment of genetically modified seeds is included here. This class excludes: - growing of seeds, see groups 011 and 012 - processing of seeds to obtain oil, see 1040 - research to develop or modify new forms of seeds, see 7210$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0170, 'Hunting, trapping and related service activities', $$This class includes: - hunting and trapping on a commercial basis - taking of animals (dead or alive) for food, fur, skin, or for use in research, in zoos or as pets - production of fur skins, reptile or bird skins from hunting or trapping activities This class also includes: - land-based catching of sea mammals such as walrus and seal This class excludes: - production of fur skins, reptile or bird skins from ranching operations, see group 014 - raising of game animals on ranching operations, see 0149 - catching of whales, see 0311 - production of hides and skins originating from slaughterhouses, see 1010 - hunting for sport or recreation and related service activities, see 9319 - service activities to promote hunting and trapping, see 9499$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0210, 'Silviculture and other forestry activities', $$This class includes: - growing of standing timber: planting, replanting, transplanting, thinning and conserving of forests and timber tracts - growing of coppice, pulpwood and fire wood - operation of forest tree nurseries These activities can be carried out in natural or planted forests. This class excludes: - growing of Christmas trees, see 0129 - operation of tree nurseries, see 0130 - gathering of wild growing non-wood forest products, see 0230 - production of wood chips and particles, see 1610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0220, 'Logging', $$This class includes: - production of roundwood for forest-based manufacturing industries - production of roundwood used in an unprocessed form such as pit-props, fence posts and utility poles - gathering and production of fire wood - production of charcoal in the forest (using traditional methods) The output of this activity can take the form of logs, chips or fire wood. This class excludes: - growing of Christmas trees, see 0129 - growing of standing timber: planting, replanting, transplanting, thinning and conserving of forests and timber tracts, see 0210 - gathering of wild growing non-wood forest products, see 0230 - production of wood chips and particles, not associated with logging, see 1610 - production of charcoal through distillation of wood, see 2011$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0230, 'Gathering of non-wood forest products', $$This class includes the gathering of non-wood forest products and other plants growing in the wild. This class includes: - gathering of wild growing materials: - mushrooms, truffles - berries - nuts - balata and other rubber-like gums - cork - lac and resins - balsams - vegetable hair - eelgrass - acorns, horse chestnuts - mosses and lichens This class excludes: - managed production of any of these products (except growing of cork trees), see division 01 - growing of mushrooms or truffles, see 0113 - growing of berries or nuts, see 0125 - gathering of fire wood, see 0220$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0240, 'Support services to forestry', $$This class includes carrying out part of the forestry operation on a fee or contract basis. This class includes: - forestry service activities: - forestry inventories - forest management consulting services - timber evaluation - forest fire fighting and protection - forest pest control - logging service activities: - transport of logs within the forest This class excludes: - operation of forest tree nurseries, see 0210$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0311, 'Marine fishing', $$This class includes: - fishing on a commercial basis in ocean and coastal waters - taking of marine crustaceans and molluscs - whale catching - taking of marine aquatic animals: turtles, sea squirts, tunicates, sea urchins etc. This class also includes: - activities of vessels engaged both in fishing and in processing and preserving of fish - gathering of other marine organisms and materials: natural pearls, sponges, coral and algae This class excludes: - capturing of marine mammals, except whales, e.g. walruses, seals, see 0170 - processing of fish, crustaceans and molluscs on factory ships or in factories ashore, see 1020 - renting of pleasure boats with crew for sea and coastal water transport (e.g. for fishing cruises), see 5011 - fishing inspection, protection and patrol services, see 8423 - fishing practiced for sport or recreation and related services, see 9319 - operation of sport fishing preserves, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0312, 'Freshwater fishing', $$This class includes: - fishing on a commercial basis in inland waters - taking of freshwater crustaceans and molluscs - taking of freshwater aquatic animals This class also includes: - gathering of freshwater materials This class excludes: - processing of fish, crustaceans and molluscs, see 1020 - fishing inspection, protection and patrol services, see 8423 - fishing practiced for sport or recreation and related services, see 9319 - operation of sport fishing preserves, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0321, 'Marine aquaculture', $$This class includes: - fish farming in sea water including farming of marine ornamental fish - production of bivalve spat (oyster mussel etc.), lobsterlings, shrimp post-larvae, fish fry and fingerlings - growing of laver and other edible seaweeds - culture of crustaceans, bivalves, other molluscs and other aquatic animals in sea water This class also includes: - aquaculture activities in brackish waters - aquaculture activities in salt water filled tanks or reservoirs - operation of fish hatcheries (marine) - operation of marine worm farms This class excludes: - frog farming, see 0322 - operation of sport fishing preserves, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0322, 'Freshwater aquaculture', $$This class includes: - fish farming in freshwater including farming of freshwater ornamental fish - culture of freshwater crustaceans, bivalves, other molluscs and other aquatic animals - operation of fish hatcheries (freshwater) - farming of frogs This class excludes: - aquaculture activities in salt water filled tanks and reservoirs, see 0321 - operation of sport fishing preserves, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0510, 'Mining of hard coal', $$This class includes: - mining of hard coal: underground or surface mining, including mining through liquefaction methods - cleaning, sizing, grading, pulverizing, compressing etc. of coal to classify, improve quality or facilitate transport or storage This class also includes: - recovery of hard coal from culm banks This class excludes: - lignite mining, see 0520 - peat digging and agglomeration of peat, see 0892 - test drilling for coal mining, see 0990 - support activities for hard coal mining, see 0990 - coke ovens producing solid fuels, see 1910 - manufacture of hard coal briquettes, see 1920 - work performed to develop or prepare properties for coal mining, see 4312$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0520, 'Mining of lignite', $$This class includes: - mining of lignite (brown coal): underground or surface mining, including mining through liquefaction methods - washing, dehydrating, pulverizing, compressing of lignite to improve quality or facilitate transport or storage This class excludes: - hard coal mining, see 0510 - peat digging, see 0892 - test drilling for coal mining, see 0990 - support activities for lignite mining, see 0990 - manufacture of lignite fuel briquettes, see 1920 - work performed to develop or prepare properties for coal mining, see 4312$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0610, 'Extraction of crude petroleum', $$This class includes: - extraction of crude petroleum oils This class also includes: - extraction of bituminous or oil shale and tar sand - production of crude petroleum from bituminous shale and sand - processes to obtain crude oils: decantation, desalting, dehydration, stabilization etc. This class excludes: - support activities for oil and gas extraction, see 0910 - oil and gas exploration, see 0910 - manufacture of refined petroleum products, see 1920 - recovery of liquefied petroleum gases in the refining of petroleum, see 1920 - operation of pipelines, see 4930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0620, 'Extraction of natural gas', $$This class includes: - production of crude gaseous hydrocarbon (natural gas) - extraction of condensates - draining and separation of liquid hydrocarbon fractions - gas desulphurization This class also includes: - mining of hydrocarbon liquids, obtained through liquefaction or pyrolysis This class excludes: - support activities for oil and gas extraction, see 0910 - oil and gas exploration, see 0910 - recovery of liquefied petroleum gases in the refining of petroleum, see 1920 - manufacture of industrial gases, see 2011 - operation of pipelines, see 4930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0710, 'Mining of iron ores', $$This class includes: - mining of ores valued chiefly for iron content - beneficiation and agglomeration of iron ores This class excludes: - extraction and preparation of pyrites and pyrrhotite (except roasting), see 0891$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0721, 'Mining of uranium and thorium ores', $$This class includes: - mining of ores chiefly valued for uranium and thorium content: pitchblende etc. - concentration of such ores - production of yellowcake This class excludes: - enrichment of uranium and thorium ores, see 2011 - production of uranium metal from pitchblende or other ores, see 2420 - smelting and refining of uranium, see 2420$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	0729, 'Mining of other non-ferrous metal ores', $$This class includes: - mining and preparation of ores valued chiefly for non-ferrous metal content: - aluminium (bauxite), copper, lead, zinc, tin, manganese, chrome, nickel, cobalt, molybdenum, tantalum, vanadium etc. - precious metals: gold, silver, platinum This class excludes: - mining and preparation of uranium and thorium ores, see 0721 - production of aluminium oxide and mattes of nickel or of copper, see 2420$$
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0810, 'Quarrying of stone, sand and clay', $$This class includes: - mining of natural phosphates and natural potassium salts - mining of native sulphur - extraction and preparation of pyrites and pyrrhotite, except roasting - mining of natural barium sulphate and carbonate (barytes and witherite), natural borates, natural magnesium sulphates (kieserite) - mining of earth colours, fluorspar and other minerals valued chiefly as a source of chemicals This class also includes: - guano mining This class excludes: - extraction of salt, see 0893 - roasting of iron pyrites, see 2011 - manufacture of synthetic fertilizers and nitrogen compounds, see 2012$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0891, 'Mining of chemical and fertilizer minerals', $$This class includes: - mining of natural phosphates and natural potassium salts - mining of native sulphur - extraction and preparation of pyrites and pyrrhotite, except roasting - mining of natural barium sulphate and carbonate (barytes and witherite), natural borates, natural magnesium sulphates (kieserite) - mining of earth colours, fluorspar and other minerals valued chiefly as a source of chemicals This class also includes: - guano mining This class excludes: - extraction of salt, see 0893 - roasting of iron pyrites, see 2011 - manufacture of synthetic fertilizers and nitrogen compounds, see 2012$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0892, 'Extraction of peat', $$This class includes: - peat digging - peat agglomeration - preparation of peat to improve quality or facilitate transport or storage This class excludes: - service activities incidental to peat mining, see 0990 - manufacture of articles of peat, see 2399$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0893 , 'Extraction of salt', $$This class includes: - extraction of salt from underground including by dissolving and pumping - salt production by evaporation of sea water or other saline waters - crushing, purification and refining of salt by the producer This class excludes: - processing of salt into food-grade salt, e.g. iodized salt, see 1079 - potable water production by evaporation of saline water, see 3600$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0899 , 'Other mining and quarrying n.e.c.', $$This class includes: - mining and quarrying of various minerals and materials: - abrasive materials, asbestos, siliceous fossil meals, natural graphite, steatite (talc), feldspar etc. - natural asphalt, asphaltites and asphaltic rock; natural solid bitumen - gemstones, quartz, mica etc$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0910, 'Support activities for petroleum and natural gas extraction', $$This class includes: - oil and gas extraction service activities provided on a fee or contract basis: - exploration services in connection with petroleum or gas extraction, e.g. traditional prospecting methods, such as making geological observations at prospective sites - directional drilling and redrilling; "spudding in"; derrick erection in situ, repairing and dismantling; cementing oil and gas well casings; pumping of wells; plugging and abandoning wells etc. - liquefaction and regasification of natural gas for purpose of transport, done at the mine site - draining and pumping services, on a fee or contract basis - test drilling in connection with petroleum or gas extraction This class also includes: - oil and gas field fire fighting services This class excludes: - service activities performed by operators of oil or gas fields, see 0610, 0620 - specialized repair of mining machinery, see 3312 - liquefaction and regasification of natural gas for purpose of transport, done off the mine site, see 5221 - geophysical, geologic and seismic surveying, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	0990, 'Support activities for other mining and quarrying', $$This class includes: - support services on a fee or contract basis, required for mining activities of divisions 05, 07 and 08 - exploration services, e.g. traditional prospecting methods, such as taking core samples and making geological observations at prospective sites - draining and pumping services, on a fee or contract basis - test drilling and test hole boring This class excludes: - operating mines or quarries on a contract or fee basis, see division 05, 07 or 08 - specialized repair of mining machinery, see 3312 - geophysical surveying services, on a contract or fee basis, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1010, 'Processing and preserving of meat', $$This class includes: - operation of slaughterhouses engaged in killing, dressing or packing meat: beef, pork, poultry, lamb, rabbit, mutton, camel, etc. - production of fresh, chilled or frozen meat, in carcasses - production of fresh, chilled or frozen meat, in cuts - production of fresh, chilled or frozen meat, in individual portions - production of dried, salted or smoked meat - production of meat products: - sausages, salami, puddings, "andouillettes", saveloys, bolognas, pâtés, rillettes, boiled ham This class also includes: - slaughtering and processing of whales on land or on specialized vessels - production of hides and skins originating from slaughterhouses, including fellmongery - rendering of lard and other edible fats of animal origin - processing of animal offal - production of pulled wool - production of feathers and down This class excludes: - manufacture of prepared frozen meat and poultry dishes, see 1075 - manufacture of soup containing meat, see 1079 - wholesale trade of meat, see 4630 - packaging of meat, see 8292$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1020, 'Processing and preserving of fish, crustaceans and molluscs', $$This class includes: - preparation and preservation of fish, crustaceans and molluscs: freezing, deep-freezing, drying, smoking, salting, immersing in brine, canning etc. - production of fish, crustacean and mollusc products: cooked fish, fish fillets, roes, caviar, caviar substitutes etc. - production of fishmeal for human consumption or animal feed - production of meals and solubles from fish and other aquatic animals unfit for human consumption This class also includes: - activities of vessels engaged only in the processing and preserving of fish - processing of seaweed This class excludes: - processing of whales on land or specialized vessels, see 1010 - production of oils and fats from marine material, see 1040 - manufacture of prepared frozen fish dishes, see 1075 - manufacture of fish soups, see 1079$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1030, 'Processing and preserving of fruit and vegetables', $$This class includes: - manufacture of food consisting chiefly of fruit or vegetables, except ready-made dishes in frozen or canned form - preserving of fruit, nuts or vegetables: freezing, drying, immersing in oil or in vinegar, canning etc. - manufacture of fruit or vegetable food products - manufacture of fruit or vegetable juices - manufacture of jams, marmalades and table jellies - processing and preserving of potatoes: - manufacture of prepared frozen potatoes - manufacture of dehydrated mashed potatoes - manufacture of potato snacks - manufacture of potato crisps - manufacture of potato flour and meal - roasting of nuts - manufacture of nut foods and pastes This class also includes: - industrial peeling of potatoes - production of concentrates from fresh fruits and vegetables - manufacture of perishable prepared foods of fruit and vegetables, such as: - salads - peeled or cut vegetables - tofu (bean curd) This class excludes: - manufacture of flour or meal of dried leguminous vegetables, see 1061 - preservation of fruit and nuts in sugar, see 1073 - manufacture of prepared vegetable dishes, see 1075 - manufacture of artificial concentrates, see 1079$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1040, 'Manufacture of vegetable and animal oils and fats', $$This class includes the manufacture of crude and refined oils and fats from vegetable or animal materials, except rendering or refining of lard and other edible animal fats. This class includes: - manufacture of crude vegetable oils: olive oil, soya-bean oil, palm oil, sunflower-seed oil, cotton-seed oil, rape, colza or mustard oil, linseed oil etc. - manufacture of non-defatted flour or meal of oilseeds, oil nuts or oil kernels - manufacture of refined vegetable oils: olive oil, soya-bean oil etc. - processing of vegetable oils: blowing, boiling, dehydration, hydrogenation etc. - manufacture of margarine - manufacture of melanges and similar spreads - manufacture of compound cooking fats This class also includes: - manufacture of non-edible animal oils and fats - extraction of fish and marine mammal oils - production of cotton linters, oilcakes and other residual products of oil production This class excludes: - rendering and refining of lard and other edible animal fats, see 1010 - wet corn milling, see 1062 - production of essential oils, see 2029 - treatment of oil and fats by chemical processes, see 2029$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1050, 'Manufacture of dairy products', $$This class includes: - manufacture of fresh liquid milk, pasteurized, sterilized, homogenized and/or ultra heat treated - manufacture of milk-based drinks - manufacture of cream from fresh liquid milk, pasteurized, sterilized, homogenized - manufacture of dried or concentrated milk whether or not sweetened - manufacture of milk or cream in solid form - manufacture of butter - manufacture of yoghurt - manufacture of cheese and curd - manufacture of whey - manufacture of casein or lactose - manufacture of ice cream and other edible ice such as sorbet This class excludes: - production of raw milk (cattle), see 0141 - production of raw milk (camels, etc.), see 0143 - production of raw milk (sheep, goats, horses, asses, etc.), see 0144 - manufacture of non-dairy milk and cheese substitutes, see 1079 - activities of ice cream parlours, see 5610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1061, 'Manufacture of grain mill products', $$This class includes: - grain milling: production of flour, groats, meal or pellets of wheat, rye, oats, maize (corn) or other cereal grains - rice milling: production of husked, milled, polished, glazed, parboiled or converted rice; production of rice flour - vegetable milling: production of flour or meal of dried leguminous vegetables, of roots or tubers, or of edible nuts - manufacture of cereal breakfast foods - manufacture of flour mixes and prepared blended flour and dough for bread, cakes, biscuits or pancakes This class excludes: - manufacture of potato flour and meal, see 1030 - wet corn milling, see 1062$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1062, 'Manufacture of starches and starch products', $$This class includes: - manufacture of starches from rice, potatoes, maize etc. - wet corn milling - manufacture of glucose, glucose syrup, maltose, inulin etc. - manufacture of gluten - manufacture of tapioca and tapioca substitutes prepared from starch - manufacture of corn oil This class excludes: - manufacture of lactose (milk sugar), see 1050 - production of cane or beet sugar, see 1072$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1071, 'Manufacture of bakery products', $$This class includes the manufacture of fresh, frozen or dry bakery products. This class includes: - manufacture of bread and rolls - manufacture of fresh pastry, cakes, pies, tarts etc. - manufacture of rusks, biscuits and other "dry" bakery products - manufacture of preserved pastry goods and cakes - manufacture of snack products (cookies, crackers, pretzels etc.), whether sweet or salted - manufacture of tortillas - manufacture of frozen bakery products: pancakes, waffles, rolls etc. This class excludes: - manufacture of farinaceous products (pastas), see 1074 - manufacture of potato snacks, see 1030 - heating up of bakery items for immediate consumption, see division 56$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1072, 'Manufacture of sugar', $$This class includes: - manufacture or refining of sugar (sucrose) and sugar substitutes from the juice of cane, beet, maple and palm - manufacture of sugar syrups - manufacture of molasses - production of maple syrup and sugar This class excludes: - manufacture of glucose, glucose syrup, maltose, see 1062$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1073, 'Manufacture of cocoa, chocolate and sugar confectionery', $$This class includes: - manufacture of cocoa, cocoa butter, cocoa fat, cocoa oil - manufacture of chocolate and chocolate confectionery - manufacture of sugar confectionery: caramels, cachous, nougats, fondant, white chocolate - manufacture of chewing gum - preserving in sugar of fruit, nuts, fruit peels and other parts of plants - manufacture of confectionery lozenges and pastilles This class excludes: - manufacture of sucrose sugar, see 1072$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1074, 'Manufacture of macaroni, noodles, couscous and similar farinaceous products', $$This class includes: - manufacture of pastas such as macaroni and noodles, whether or not cooked or stuffed - manufacture of couscous - manufacture of canned or frozen pasta products This class excludes: - manufacture of prepared couscous dishes, see 1075 - manufacture of soup containing pasta, see 1079$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1075, 'Manufacture of prepared meals and dishes', $$This class includes the manufacture of ready-made (i.e. prepared, seasoned and cooked) meals and dishes. These dishes are processed to preserve them, such as in frozen or canned form, and are usually packaged and labeled for re-sale, i.e. this class does not include the preparation of meals for immediate consumption, such as in restaurants. To be considered a dish, these foods have to contain at least two distinct main ingredients (except seasonings etc.). This class includes: - manufacture of meat or poultry dishes - manufacture of fish dishes, including fish and chips - manufacture of prepared dishes of vegetables - manufacture of canned stews and vacuum-prepared meals - manufacture of other prepared meals (such as "TV dinners", etc.) - manufacture of frozen or otherwise preserved pizza This class excludes: - manufacture of fresh foods or foods with only one main ingredient, see division 10 - preparation of meals and dishes for immediate consumption, see division 56 - activities of food service contractors, see 5629$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1079, 'Manufacture of other food products n.e.c.', $$This class includes: - decaffeinating and roasting of coffee - production of coffee products: - ground coffee - soluble coffee - extracts and concentrates of coffee - manufacture of coffee substitutes - blending of tea and maté - manufacture of extracts and preparations based on tea or maté - manufacture of soups and broths - manufacture of special foods, such as: - infant formula - follow up milks and other follow up foods - baby foods - foods containing homogenized ingredients - manufacture of spices, sauces and condiments: - mayonnaise - mustard flour and meal - prepared mustard etc. - manufacture of vinegar - manufacture of artificial honey and caramel - manufacture of perishable prepared foods, such as: - sandwiches - fresh (uncooked) pizza This class also includes: - manufacture of herb infusions (mint, vervain, chamomile etc.) - manufacture of yeast - manufacture of extracts and juices of meat, fish, crustaceans or molluscs - manufacture of non-dairy milk and cheese substitutes - manufacture of egg products, egg albumin - processing of salt into food-grade salt, e.g. iodized salt - manufacture of artificial concentrates This class excludes: - growing of spice crops, see 0128 - manufacture of inulin, see 1062 - manufacture of perishable prepared foods of fruit and vegetables (e.g. salads, peeled vegetables, bean curd), see 1030 - manufacture of frozen pizza, see 1075 - manufacture of spirits, beer, wine and soft drinks, see division 11 - preparation of botanical products for pharmaceutical use, see 2100$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1080, 'Manufacture of prepared animal feeds', $$This class includes: - manufacture of prepared feeds for pets, including dogs, cats, birds, fish etc. - manufacture of prepared feeds for farm animals, including animal feed concentrates and feed supplements - preparation of unmixed (single) feeds for farm animals This class also includes: - treatment of slaughter waste to produce animal feeds This class excludes: - production of fishmeal for animal feed, see 1020 - production of oilseed cake, see 1040 - activities resulting in by-products usable as animal feed without special treatment, e.g. oilseeds (see 1040), grain milling residues (see 1061) etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1910, 'Manufacture of coke oven products', $$This class includes: - operation of coke ovens - production of coke and semi-coke - production of pitch and pitch coke - production of coke oven gas - production of crude coal and lignite tars - agglomeration of coke$$ 
);


INSERT INTO "isic_class" (code,name,description) VALUES ( 
	1920, 'Manufacture of refined petroleum products', $$This class includes the manufacture of liquid or gaseous fuels or other products from crude petroleum, bituminous minerals or their fractionation products. Petroleum refining involves one or more of the following activities: fractionation, straight distillation of crude oil, and cracking. This class includes: - production of motor fuel: gasoline, kerosene etc. - production of fuel: light, medium and heavy fuel oil, refinery gases such as ethane, propane, butane etc. - manufacture of oil-based lubricating oils or greases, including from waste oil - manufacture of products for the petrochemical industry and for the manufacture of road coverings - manufacture of various products: white spirit, Vaseline, paraffin wax, petroleum jelly etc. - manufacture of hard-coal and lignite fuel briquettes - manufacture of petroleum briquettes - blending of biofuels, i.e. blending of alcohols with petroleum (e.g. gasohol)$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES ( 
	2011, 'Manufacture of basic chemicals', $$This class includes the manufacture of chemicals using basic processes, such as thermal cracking and distillation. The output of these processes are usually separate chemical elements or separate chemically defined compounds. This class includes: - manufacture of liquefied or compressed inorganic industrial or medical gases: - elemental gases - liquid or compressed air - refrigerant gases - mixed industrial gases - inert gases such as carbon dioxide - isolating gases - manufacture of dyes and pigments from any source in basic form or as concentrate - manufacture of chemical elements - manufacture of inorganic acids except nitric acid - manufacture of alkalis, lyes and other inorganic bases except ammonia - manufacture of other inorganic compounds - manufacture of basic organic chemicals: - acyclic hydrocarbons, saturated and unsaturated - cyclic hydrocarbons, saturated and unsaturated - acyclic and cyclic alcohols - mono- and polycarboxylic acids, including acetic acid - other oxygen-function compounds, including aldehydes, ketones, quinones and dual or poly oxygen-function compounds - synthetic glycerol - nitrogen-function organic compounds, including amines - fermentation of sugarcane, corn or similar to produce alcohol and esters - other organic compounds, including wood distillation products (e.g. charcoal) etc. - manufacture of distilled water - manufacture of synthetic aromatic products - roasting of iron pyrites This class also includes: - manufacture of products of a kind used as fluorescent brightening agents or as luminophores - enrichment of uranium and thorium ores and production of fuel elements for nuclear reactors This class excludes: - extraction of methane, ethane, butane or propane, see 0620 - manufacture of fuel gases such as ethane, butane or propane in a petroleum refinery, see 1920 - manufacture of nitrogenous fertilizers and nitrogen compounds, see 2012 - manufacture of ammonia, see 2012 - manufacture of ammonium chloride, see 2012 - manufacture of nitrites and nitrates of potassium, see 2012 - manufacture of ammonium carbonates, see 2012 - manufacture of plastics in primary forms, see 2013 - manufacture of synthetic rubber in primary forms, see 2013 - manufacture of prepared dyes and pigments, see 2022 - manufacture of crude glycerol, see 2023 - manufacture of natural essential oils, see 2029 - manufacture of aromatic distilled waters, see 2029 - manufacture of salicylic and O-acetylsalicylic acids, see 2100$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2012, 'Manufacture of fertilizers and nitrogen compounds', $$This class includes: - manufacture of fertilizers: - straight or complex nitrogenous, phosphatic or potassic fertilizers - urea, crude natural phosphates and crude natural potassium salts - manufacture of associated nitrogen products: - nitric and sulphonitric acids, ammonia, ammonium chloride, ammonium carbonate, nitrites and nitrates of potassium This class also includes: - manufacture of potting soil with peat as main constituent - manufacture of potting soil mixtures of natural soil, sand, clays and minerals This class excludes: - mining of guano, see 0891 - manufacture of agrochemical products, such as pesticides, see 2021 - operation of compost dumps, see 3821$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2013, 'Manufacture of plastics and synthetic rubber in primary forms', $$This class includes the manufacture of resins, plastics materials and non-vulcanizable thermoplastic elastomers, the mixing and blending of resins on a custom basis, as well as the manufacture of non-customized synthetic resins. This class includes: - manufacture of plastics in primary forms: - polymers, including those of ethylene, propylene, styrene, vinyl chloride, vinyl acetate and acrylics - polyamides - phenolic and epoxide resins and polyurethanes - alkyd and polyester resins and polyethers - silicones - ion-exchangers based on polymers - manufacture of synthetic rubber in primary forms: - synthetic rubber - factice - manufacture of mixtures of synthetic rubber and natural rubber or rubber-like gums (e.g. balata) This class also includes: - manufacture of cellulose and its chemical derivatives This class excludes: - manufacture of artificial and synthetic fibres, filaments and yarn, see 2030 - shredding of plastic products, see 3830$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2021, 'Manufacture of pesticides and other agrochemical products', $$This class includes: - manufacture of insecticides, rodenticides, fungicides, herbicides - manufacture of anti-sprouting products, plant growth regulators - manufacture of disinfectants (for agricultural and other use) - manufacture of other agrochemical products n.e.c. This class excludes: - manufacture of fertilizers and nitrogen compounds, see 2012$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2022, 'Manufacture of paints, varnishes and similar coatings, printing ink and mastics', $$This class includes: - manufacture of paints and varnishes, enamels or lacquers - manufacture of prepared pigments and dyes, opacifiers and colours - manufacture of vitrifiable enamels and glazes and engobes and similar preparations - manufacture of mastics - manufacture of caulking compounds and similar non-refractory filling or surfacing preparations - manufacture of organic composite solvents and thinners - manufacture of prepared paint or varnish removers - manufacture of printing ink This class excludes: - manufacture of dyestuffs and pigments, see 2011 - manufacture of writing and drawing ink, see 2029$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2023, 'Manufacture of soap and detergents, cleaning and polishing preparations, perfumes and toilet preparations', $$This class includes: - manufacture of organic surface-active agents - manufacture of soap - manufacture of paper, wadding, felt etc. coated or covered with soap or detergent - manufacture of crude glycerol - manufacture of surface-active preparations: - washing powders in solid or liquid form and detergents - dish-washing preparations - textile softeners - manufacture of cleaning and polishing products: - preparations for perfuming or deodorizing rooms - artificial waxes and prepared waxes - polishes and creams for leather - polishes and creams for wood - polishes for coachwork, glass and metal - scouring pastes and powders, including paper, wadding etc. coated or covered with these - manufacture of perfumes and toilet preparations: - perfumes and toilet water - beauty and make-up preparations - sunburn prevention and suntan preparations - manicure and pedicure preparations - shampoos, hair lacquers, waving and straightening preparations - dentifrices and preparations for oral hygiene, including denture fixative preparations - shaving preparations, including pre-shave and aftershave preparations - deodorants and bath salts - depilatories This class excludes: - manufacture of separate, chemically defined compounds, see 2011 - manufacture of glycerol, synthesized from petroleum products, see 2011 - extraction and refining of natural essential oils, see 2029$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2029, 'Manufacture of other chemical products n.e.c.', $$This class includes: - manufacture of propellant powders - manufacture of explosives and pyrotechnic products, including percussion caps, detonators, signalling flares etc. - manufacture of gelatine and its derivatives, glues and prepared adhesives, including rubber-based glues and adhesives - manufacture of extracts of natural aromatic products - manufacture of resinoids - manufacture of aromatic distilled waters - manufacture of mixtures of odoriferous products for the manufacture of perfumes or food - manufacture of photographic plates, films, sensitized paper and other sensitized unexposed materials - manufacture of chemical preparations for photographic uses - manufacture of various chemical products: - peptones, peptone derivatives, other protein substances and their derivatives n.e.c. - essential oils - chemically modified oils and fats - materials used in the finishing of textiles and leather - powders and pastes used in soldering, brazing or welding - substances used to pickle metal - prepared additives for cements - activated carbon, lubricating oil additives, prepared rubber accelerators, catalysts and other chemical products for industrial use - anti-knock preparations, antifreeze preparations - composite diagnostic or laboratory reagents This class also includes: - manufacture of writing and drawing ink - manufacture of matches This class excludes: - manufacture of chemically defined products in bulk, see 2011 - manufacture of distilled water, see 2011 - manufacture of synthetic aromatic products, see 2011 - manufacture of printing ink, see 2022 - manufacture of perfumes and toilet preparations, see 2023 - manufacture of asphalt-based adhesives, see 2399$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2030, 'Manufacture of man-made fibres', $$This class includes: - manufacture of synthetic or artificial filament tow - manufacture of synthetic or artificial staple fibres, not carded, combed or otherwise processed for spinning - manufacture of synthetic or artificial filament yarn, including high-tenacity yarn - manufacture of synthetic or artificial monofilament or strip This class excludes: - spinning of synthetic or artificial fibres, see 1311 - manufacture of yarns made of man-made staple, see 1311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2100, 'Manufacture of pharmaceuticals, medicinal chemical and botanical products', $$This class includes: - manufacture of medicinal active substances to be used for their pharmacological properties in the manufacture of medicaments: antibiotics, basic vitamins, salicylic and O-acetylsalicylic acids etc. - processing of blood - manufacture of medicaments: - antisera and other blood fractions - vaccines - diverse medicaments, including homeopathic preparations - manufacture of chemical contraceptive products for external use and hormonal contraceptive medicaments - manufacture of medical diagnostic preparations, including pregnancy tests - manufacture of radioactive in-vivo diagnostic substances - manufacture of biotech pharmaceuticals This class also includes: - manufacture of chemically pure sugars - processing of glands and manufacture of extracts of glands etc. - manufacture of medical impregnated wadding, gauze, bandages, dressings etc. - preparation of botanical products (grinding, grading, milling) for pharmaceutical use This class excludes: - manufacture of herb infusions (mint, vervain, chamomile etc.), see 1079 - manufacture of dental fillings and dental cement, see 3250 - manufacture of bone reconstruction cements, see 3250 - wholesale of pharmaceuticals, see 4649 - retail sale of pharmaceuticals, see 4772 - research and development for pharmaceuticals and biotech pharmaceuticals, see 7210 - packaging of pharmaceuticals, see 8292$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2211, 'Manufacture of rubber tires and tubes; retreading and rebuilding of rubber tires', $$This class includes: - manufacture of rubber tyres for vehicles, equipment, mobile machinery, aircraft, toy, furniture and other uses: - pneumatic tyres - solid or cushion tyres - manufacture of inner tubes for tyres - manufacture of interchangeable tyre treads, tyre flaps, "camelback" strips for retreading tyres etc. - tyre rebuilding and retreading This class excludes: - manufacture of tube repair materials, see 2219 - tyre and tube repair, fitting or replacement, see 4520$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2219, 'Manufacture of other rubber products', $$This class includes: - manufacture of other products of natural or synthetic rubber, unvulcanized, vulcanized or hardened: - rubber plates, sheets, strip, rods, profile shapes - tubes, pipes and hoses - rubber conveyor or transmission belts or belting - rubber hygienic articles: sheath contraceptives, teats, hot water bottles etc. - rubber articles of apparel (if only sealed together, not sewn) - rubber thread and rope - rubberized yarn and fabrics - rubber rings, fittings and seals - rubber roller coverings - inflatable rubber mattresses - inflatable balloons - manufacture of rubber brushes - manufacture of hard rubber pipe stems - manufacture of hard rubber combs, hair pins, hair rollers, and similar This class also includes: - manufacture of rubber repair materials - manufacture of textile fabric impregnated, coated, covered or laminated with rubber, where rubber is the chief constituent - manufacture of rubber waterbed mattresses - manufacture of rubber bathing caps and aprons - manufacture of rubber wet suits and diving suits - manufacture of rubber sex articles This class excludes: - manufacture of tyre cord fabrics, see 1399 - manufacture of apparel of elastic fabrics, see 1410 - manufacture of rubber footwear, see 1520 - manufacture of glues and adhesives based on rubber, see 2029 - manufacture of "camelback" strips, see 2211 - manufacture of inflatable rafts and boats, see 3011, 3012 - manufacture of mattresses of uncovered cellular rubber, see 3100 - manufacture of rubber sports requisites, except apparel, see 3230 - manufacture of rubber games and toys (including children's wading pools, inflatable children rubber boats, inflatable rubber animals, balls and the like), see 3240 - reclaiming of rubber, see 3830$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	 2220, 'Manufacture of plastics products', $$This class includes the processing of new or spent (i.e. recycled) plastics resins into intermediate or final products, using such processes as compression molding, extrusion molding, injection molding, blow molding and casting. For most of these, the production process is such that a wide variety of products can be made. This class includes: - manufacture of semi-manufactures of plastic products: - plastic plates, sheets, blocks, film, foil, strip etc. (whether self-adhesive or not) - manufacture of finished plastic products: - plastic tubes, pipes and hoses; hose and pipe fittings - manufacture of plastic articles for the packing of goods: - plastic bags, sacks, containers, boxes, cases, carboys, bottles etc. - manufacture of builders' plastics ware: - plastic doors, windows, frames, shutters, blinds, skirting boards - tanks, reservoirs - plastic floor, wall or ceiling coverings in rolls or in the form of tiles etc. - plastic sanitary ware, such as: - plastic baths, shower baths, washbasins, lavatory pans, flushing cisterns etc. - manufacture of plastic tableware, kitchenware and toilet articles - cellophane film or sheet - manufacture of resilient floor coverings, such as vinyl, linoleum etc. - manufacture of artificial stone (e.g. cultured marble) - manufacture of plastic signs (non-electrical) - manufacture of diverse plastic products: - plastic headgear, insulating fittings, parts of lighting fittings, office or school supplies, articles of apparel (if only sealed together, not sewn), fittings for furniture, statuettes, transmission and conveyer belts, self-adhesive tapes of plastic, plastic wall paper, plastic shoe lasts, plastic cigar and cigarette holders, combs, plastics hair curlers, plastics novelties, etc. This class excludes: - manufacture of plastic luggage, see 1512 - manufacture of plastic footwear, see 1520 - manufacture of plastics in primary forms, see 2013 - manufacture of articles of synthetic or natural rubber, see group 221 - manufacture of plastic non current-carrying wiring devices (e.g. junction boxes, face plates), see 2733 - manufacture of plastic furniture, see 3100 - manufacture of mattresses of uncovered cellular plastic, see 3100 - manufacture of plastic sports requisites, see 3230 - manufacture of plastic games and toys, see 3240 - manufacture of plastic medical and dental appliances, see 3250 - manufacture of plastic ophthalmic goods, see 3250 - manufacture of plastics hard hats and other personal safety equipment of plastics, see 3290$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2310, 'Manufacture of glass and glass products', $$This class includes the manufacture of glass in all forms, made by any process and the manufacture of articles of glass. This class includes: - manufacture of flat glass, including wired, coloured or tinted flat glass - manufacture of toughened or laminated flat glass - manufacture of glass in rods or tubes - manufacture of glass paving blocks - manufacture of glass mirrors - manufacture of multiple-walled insulating units of glass - manufacture of bottles and other containers of glass or crystal - manufacture of drinking glasses and other domestic glass or crystal articles - manufacture of glass fibres, including glass wool and non-woven products thereof - manufacture of laboratory, hygienic or pharmaceutical glassware - manufacture of clock or watch glasses, optical glass and optical elements not optically worked - manufacture of glassware used in imitation jewellery - manufacture of glass insulators and glass insulating fittings - manufacture of glass envelopes for lamps - manufacture of glass figurines This class excludes: - manufacture of woven fabrics of glass yarn, see 1312 - manufacture of optical elements optically worked, see 2670 - manufacture of fiber optic cable for data transmission or live transmission of images, see 2731 - manufacture of glass toys, see 3240 - manufacture of syringes and other medical laboratory equipment, see 3250$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2391, 'Manufacture of refractory products', $$This class includes: - manufacture of refractory mortars, concretes etc. - manufacture of refractory ceramic goods: - heat-insulating ceramic goods of siliceous fossil meals - refractory bricks, blocks and tiles etc. - retorts, crucibles, muffles, nozzles, tubes, pipes etc. This class also includes: - manufacture of refractory articles containing magnesite, dolomite or chromite$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2392, 'Manufacture of clay building materials', $$This class includes: - manufacture of non-refractory ceramic hearth or wall tiles, mosaic cubes etc. - manufacture of non-refractory ceramic flags and paving - manufacture of structural non-refractory clay building materials: - manufacture of ceramic bricks, roofing tiles, chimney pots, pipes, conduits etc. - manufacture of flooring blocks in baked clay - manufacture of ceramic sanitary fixtures This class excludes: - manufacture of artificial stone (e.g. cultured marble), see 2220 - manufacture of refractory ceramic products, see 2391$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2393, 'Manufacture of other porcelain and ceramic products', $$This class includes: - manufacture of ceramic tableware and other domestic or toilet articles - manufacture of statuettes and other ornamental ceramic articles - manufacture of electrical insulators and insulating fittings of ceramics - manufacture of ceramic and ferrite magnets - manufacture of ceramic laboratory, chemical and industrial products - manufacture of ceramic pots, jars and similar articles of a kind used for conveyance or packing of goods - manufacture of ceramic furniture - manufacture of ceramic products n.e.c. This class excludes: - manufacture of artificial stone (e.g. cultured marble), see 2220 - manufacture of refractory ceramic goods, see 2391 - manufacture of ceramic building materials, see 2392 - manufacture of ceramic sanitary fixtures, see 2392 - manufacture of permanent metallic magnets, see 2599 - manufacture of imitation jewellery, see 3212 - manufacture of ceramic toys, see 3240 - manufacture of artificial teeth, see 3250$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2394, 'Manufacture of cement, lime and plaster', $$This class includes: - manufacture of clinkers and hydraulic cements, including Portland, aluminous cement, slag cement and superphosphate cements - manufacture of quicklime, slaked lime and hydraulic lime - manufacture of plasters of calcined gypsum or calcined sulphate - manufacture of calcined dolomite This class excludes: - manufacture of refractory mortars, concrete etc., see 2391 - manufacture of articles of cement, see 2395 - manufacture of articles of plaster, see 2395 - manufacture of ready-mixed and dry-mix concrete and mortars, see 2395 - manufacture of cements used in dentistry, see 3250$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2395, 'Manufacture of articles of concrete, cement and plaster', $$This class includes: - manufacture of precast concrete, cement or artificial stone articles for use in construction: - tiles, flagstones, bricks, boards, sheets, panels, pipes, posts etc. - manufacture of prefabricated structural components for buildings or civil engineering of cement, concrete or artificial stone - manufacture of plaster articles for use in construction: - boards, sheets, panels etc. - manufacture of building materials of vegetable substances (wood wool, straw, reeds, rushes) agglomerated with cement, plaster or other mineral binder - manufacture of articles of asbestos-cement or cellulose fibre-cement or the like: - corrugated sheets, other sheets, panels, tiles, tubes, pipes, reservoirs, troughs, basins, sinks, jars, furniture, window frames etc. - manufacture of other articles of concrete, plaster, cement or artificial stone: - statuary, furniture, bas- and haut-reliefs, vases, flowerpots etc. - manufacture of powdered mortars - manufacture of ready-mix and dry-mix concrete and mortars This class excludes: - manufacture of refractory cements and mortars, see 2391$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2396, 'Cutting, shaping and finishing of stone', $$This class includes: - cutting, shaping and finishing of stone for use in construction, in cemeteries, on roads, as roofing etc. - manufacture of stone furniture This class excludes: - production of rough cut stone, i.e. quarrying activities, see 0810 - production of millstones, abrasive stones and similar products, see 2399 - activities of sculptors, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2399, 'Manufacture of other non-metallic mineral products n.e.c.', $$This class includes: - manufacture of millstones, sharpening or polishing stones and natural or artificial abrasive products, including abrasive products on a soft base (e.g. sandpaper) - manufacture of friction material and unmounted articles thereof with a base of mineral substances or of cellulose - manufacture of mineral insulating materials: - slag wool, rock wool and similar mineral wools; exfoliated vermiculite, expanded clays and similar heat-insulating, sound-insulating or sound-absorbing materials - manufacture of articles of diverse mineral substances: - worked mica and articles of mica, of peat, of graphite (other than electrical articles) etc. - manufacture of articles of asphalt or similar material, e.g. asphalt-based adhesives, coal tar pitch etc. - carbon and graphite fibers and products (except electrodes and electrical applications) This class excludes: - manufacture of glass wool and non-woven glass wool products, see 2310 - manufacture of carbon or graphite gaskets, see 2819$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2410, 'Manufacture of basic iron and steel', $$This class includes operations of conversion by reduction of iron ore in blast furnaces and oxygen converters or of ferrous waste and scrap in electric arc furnaces or by direct reduction of iron ore without fusion to obtain crude steel which is smelted and refined in a ladle furnace and then poured and solidified in a continuous caster in order to produce semi-finished flat or long products, which are used, after reheating, in rolling, drawing and extruding operations to manufacture finished products such as plate, sheet, strip, bars, rods, wire, tubes, pipes and hollow profiles. This class includes: - operation of blast furnaces, steel converters, rolling and finishing mills - production of pig iron and spiegeleisen in pigs, blocks or other primary forms - production of ferro-alloys - production of ferrous products by direct reduction of iron and other spongy ferrous products - production of iron of exceptional purity by electrolysis or other chemical processes - production of granular iron and iron powder - production of steel in ingots or other primary forms - remelting of scrap ingots of iron or steel - production of semi-finished products of steel - manufacture of hot-rolled and cold-rolled flat-rolled products of steel - manufacture of hot-rolled bars and rods of steel - manufacture of hot-rolled open sections of steel - manufacture of steel bars and solid sections of steel by cold drawing, grinding or turning - manufacture of open sections by progressive cold forming on a roll mill or folding on a press of flat-rolled products of steel - manufacture of wire of steel by cold drawing or stretching - manufacture of sheet piling of steel and welded open sections of steel - manufacture of railway track materials (unassembled rails) of steel - manufacture of seamless tubes, pipes and hollow profiles of steel, by hot rolling, hot extrusion or hot drawing, or by cold drawing or cold rolling - manufacture of welded tubes and pipes of steel, by cold or hot forming and welding, delivered as welded or further processed by cold drawing or cold rolling or manufactured by hot forming, welding and reducing - manufacture of tube fittings of steel, such as: - flat flanges and flanges with forged collars - butt-welded fittings - threaded fittings - socket-welded fittings This class excludes: - manufacture of tubes, pipes and hollow profiles and of tube or pipe fittings of cast-iron, see 2431 - manufacture of seamless tubes and pipes of steel by centrifugal casting, see 2431 - manufacture of tube or pipe fittings of cast-steel, see 2431$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2420, 'Manufacture of basic precious and other non-ferrous metals', $$This class includes: - production of basic precious metals: - production and refining of unwrought or wrought precious metals: gold, silver, platinum etc. from ore and scrap - production of precious metal alloys - production of precious metal semi-products - production of silver rolled onto base metals - production of gold rolled onto base metals or silver - production of platinum and platinum group metals rolled onto gold, silver or base metals - production of aluminium from alumina - production of aluminium from electrolytic refining of aluminium waste and scrap - production of aluminium alloys - semi-manufacturing of aluminium - production of lead, zinc and tin from ores - production of lead, zinc and tin from electrolytic refining of lead, zinc and tin waste and scrap - production of lead, zinc and tin alloys - semi-manufacturing of lead, zinc and tin - production of copper from ores - production of copper from electrolytic refining of copper waste and scrap - production of copper alloys - manufacture of fuse wire or strip - semi-manufacturing of copper - production of chrome, manganese, nickel etc. from ores or oxides - production of chrome, manganese, nickel etc. from electrolytic and aluminothermic refining of chrome, manganese, nickel etc., waste and scrap - production of alloys of chrome, manganese, nickel etc. - semi-manufacturing of chrome, manganese, nickel etc. - production of mattes of nickel - production of uranium metal from pitchblende or other ores - smelting and refining of uranium This class also includes: - manufacture of wire of these metals by drawing - production of aluminium oxide (alumina) - production of aluminium wrapping foil - manufacture of aluminium (tin) foil laminates made from aluminum (tin) foil as primary component - manufacture of precious metal foil laminates This class excludes: - casting of non-ferrous metals, see 2432 - manufacture of precious metal jewellery, see 3211$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2431, 'Casting of iron and steel', $$This class includes the casting of iron and steel, i.e. the activities of iron and steel foundries. This class includes: - casting of semi-finished iron products - casting of grey iron castings - casting of spheroidal graphite iron castings - casting of malleable cast-iron products - casting of semi-finished steel products - casting of steel castings - manufacture of tubes, pipes and hollow profiles and of tube or pipe fittings of cast-iron - manufacture of seamless tubes and pipes of steel by centrifugal casting - manufacture of tube or pipe fittings of cast-steel$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2432, 'Casting of non-ferrous metals', $$This class includes: - casting of semi-finished products of aluminium, magnesium, titanium, zinc etc. - casting of light metal castings - casting of heavy metal castings - casting of precious metal castings - die-casting of non-ferrous metal castings$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2511, 'Manufacture of structural metal products', $$This class includes: - manufacture of metal frameworks or skeletons for construction and parts thereof (towers, masts, trusses, bridges etc.) - manufacture of industrial frameworks in metal (frameworks for blast furnaces, lifting and handling equipment etc.) - manufacture of prefabricated buildings mainly of metal: - site huts, modular exhibition elements etc. - manufacture of metal doors, windows and their frames, shutters and gates - metal room partitions for floor attachment This class excludes: - manufacture of parts for marine or power boilers, see 2513 - manufacture of assembled railway track fixtures, see 2599 - manufacture of sections of ships, see 3011$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2512, 'Manufacture of tanks, reservoirs and containers of metal', $$This class includes: - manufacture of reservoirs, tanks and similar containers of metal, of types normally installed as fixtures for storage or manufacturing use - manufacture of metal containers for compressed or liquefied gas - manufacture of central heating boilers and radiators This class excludes: - manufacture of metal casks, drums, cans, pails, boxes etc. of a kind normally used for carrying and packing of goods, see 2599$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2513, 'Manufacture of steam generators, except central heating hot water boilers', $$This class includes: - manufacture of steam or other vapour generators - manufacture of auxiliary plant for use with steam generators: - condensers, economizers, superheaters, steam collectors and accumulators - manufacture of nuclear reactors, except isotope separators - manufacture of parts for marine or power boilers This class excludes: - manufacture of central heating hot-water boilers and radiators, see 2512 - manufacture of boiler-turbine sets, see 2811 - manufacture of isotope separators, see 2829$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2520, 'Manufacture of weapons and ammunition', $$This class includes: - manufacture of heavy weapons (artillery, mobile guns, rocket launchers, torpedo tubes, heavy machine guns) - manufacture of small arms (revolvers, shotguns, light machine guns) - manufacture of air or gas guns and pistols - manufacture of war ammunition This class also includes: - manufacture of hunting, sporting or protective firearms and ammunition - manufacture of explosive devices such as bombs, mines and torpedoes This class excludes: - manufacture of percussion caps, detonators or signalling flares, see 2029 - manufacture of cutlasses, swords, bayonets etc., see 2593 - manufacture of armoured vehicles for the transport of banknotes or valuables, see 2910 - manufacture of space vehicles, see 3030 - manufacture of tanks and other fighting vehicles, see 3040$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2591, 'Forging, pressing, stamping and roll-forming of metal; powder metallurgy', $$This class includes: - forging, pressing, stamping and roll-forming of metal - powder metallurgy: production of metal objects directly from metal powders by heat treatment (sintering) or under pressure This class excludes: - production of metal powder, see 2410, 2420$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2592, 'Treatment and coating of metals; machining', $$This class includes: - plating, anodizing etc. of metals - heat treatment of metals - deburring, sandblasting, tumbling, cleaning of metals - colouring and engraving of metals - non-metallic coating of metals: - plasticizing, enamelling, lacquering etc. - hardening, buffing of metals - boring, turning, milling, eroding, planing, lapping, broaching, levelling, sawing, grinding, sharpening, polishing, welding, splicing etc. of metalwork pieces - cutting of and writing on metals by means of laser beams This class excludes: - activities of farriers, see 0162 - rolling precious metals onto base metals or other metals, see 2420$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2593, 'Manufacture of cutlery, hand tools and general hardware', $$This class includes: - manufacture of domestic cutlery such as knives, forks, spoons etc. - manufacture of other articles of cutlery: - cleavers and choppers - razors and razor blades - scissors and hair clippers - manufacture of knives and cutting blades for machines or for mechanical appliances - manufacture of hand tools such as pliers, screwdrivers etc. - manufacture of non-power-driven agricultural hand tools - manufacture of saws and saw blades, including circular saw blades and chainsaw blades - manufacture of interchangeable tools for hand tools, whether or not power-operated, or for machine tools: drills, punches, milling cutters etc. - manufacture of press tools - manufacture of blacksmiths' tools: forges, anvils etc. - manufacture of moulding boxes and moulds (except ingot moulds) - manufacture of vices, clamps - manufacture of padlocks, locks, keys, hinges and the like, hardware for buildings, furniture, vehicles etc. - manufacture of cutlasses, swords, bayonets etc. This class excludes: - manufacture of hollowware (pots, kettles etc.), dinnerware (bowls, platters etc.) or flatware (plates, saucers etc.), see 2599 - manufacture of power-driven hand tools, see 2818 - manufacture of ingot moulds, see 2823 - manufacture of cutlery of precious metal, see 3211$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2599, 'Manufacture of other fabricated metal products n.e.c.', $$This class includes: - manufacture of pails, cans, drums, buckets, boxes - manufacture of tins and cans for food products, collapsible tubes and boxes - manufacture of metallic closures - manufacture of metal cable, plaited bands and similar articles - manufacture of uninsulated metal cable or insulated cable not capable of being used as a conductor of electricity - manufacture of articles made of wire: barbed wire, wire fencing, grill, netting, cloth etc. - manufacture of nails and pins - manufacture of rivets, washers and similar non-threaded products - manufacture of screw machine products - manufacture of bolts, screws, nuts and similar threaded products - manufacture of springs (except watch springs): - leaf springs, helical springs, torsion bar springs - leaves for springs - manufacture of chain, except power transmission chain - manufacture of metal household articles: - flatware: plates, saucers etc. - hollowware: pots, kettles etc. - dinnerware: bowls, platters etc. - saucepans, frying pans and other non-electrical utensils for use at the table or in the kitchen - small hand-operated kitchen appliances and accessories - metal scouring pads - manufacture of baths, sinks, washbasins and similar articles - manufacture of metal goods for office use, except furniture - manufacture of safes, strongboxes, armoured doors etc. - manufacture of various metal articles: - ship propellers and blades thereof - anchors - bells - assembled railway track fixtures - clasps, buckles, hooks - manufacture of foil bags - manufacture of permanent metallic magnets - manufacture of metal vacuum jugs and bottles - manufacture of metal signs (non-electrical) - manufacture of metal badges and metal military insignia - manufacture of metal hair curlers, metal umbrella handles and frames, combs This class excludes: - manufacture of ceramic and ferrite magnets, see 2393 - manufacture of tanks and reservoirs, see 2512 - manufacture of swords, bayonets, see 2593 - manufacture of clock or watch springs, see 2652 - manufacture of wire and cable for electricity transmission, see 2732 - manufacture of power transmission chain, see 2814 - manufacture of shopping carts, see 3099 - manufacture of metal furniture, see 3100 - manufacture of sports goods, see 3230 - manufacture of games and toys, see 3240$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2610, 'Manufacture of electronic components and boards', $$This class includes the manufacture of semiconductors and other components for electronic applications. This class includes: - manufacture of capacitors, electronic - manufacture of resistors, electronic - manufacture of microprocessors - manufacture of bare printed circuit boards - manufacture of electron tubes - manufacture of electronic connectors - manufacture of integrated circuits (analog, digital or hybrid) - manufacture of diodes, transistors and related discrete devices - manufacture of inductors (e.g. chokes, coils, transformers), electronic component type - manufacture of electronic crystals and crystal assemblies - manufacture of solenoids, switches and transducers for electronic applications - manufacture of dice or wafers, semiconductor, finished or semi-finished - manufacture of interface cards (e.g. sound, video, controllers, network, modems) - manufacture of display components (plasma, polymer, LCD) - manufacture of light emitting diodes (LED) - loading of components onto printed circuit boards This class also includes: - manufacture of printer cables, monitor cables, USB cables, connectors etc. This class excludes: - printing of smart cards, see 1811 - manufacture of modems (carrier equipment), see 2630 - manufacture of computer and television displays, see 2620, 2640 - manufacture of X-ray tubes and similar irradiation devices, see 2660 - manufacture of optical equipment and instruments, see 2670 - manufacture of similar devices for electrical applications, see division 27 - manufacture of lighting ballasts, see 2710 - manufacture of electrical relays, see 2710 - manufacture of electrical wiring devices, see 2733 - manufacture of complete equipment is classified elsewhere based on complete equipment classification$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2620, 'Manufacture of computers and peripheral equipment', $$This class includes the manufacture and/or assembly of electronic computers, such as mainframes, desktop computers, laptops and computer servers; and computer peripheral equipment, such as storage devices and input/output devices (printers, monitors, keyboards). Computers can be analog, digital, or hybrid. Digital computers, the most common type, are devices that do all of the following: (1) store the processing program or programs and the data immediately necessary for the execution of the program, (2) can be freely programmed in accordance with the requirements of the user, (3) perform arithmetical computations specified by the user and (4) execute, without human intervention, a processing program that requires the computer to modify its execution by logical decision during the processing run. Analog computers are capable of simulating mathematical models and comprise at least analog control and programming elements. This class includes: - manufacture of desktop computers - manufacture of laptop computers - manufacture of main frame computers - manufacture of hand-held computers (e.g. PDA) - manufacture of magnetic disk drives, flash drives and other storage devices - manufacture of optical (e.g. CD-RW, CD-ROM, DVD-ROM, DVD-RW) disk drives - manufacture of printers - manufacture of monitors - manufacture of keyboards - manufacture of all types of mice, joysticks, and trackball accessories - manufacture of dedicated computer terminals - manufacture of computer servers - manufacture of scanners, including bar code scanners - manufacture of smart card readers - manufacture of virtual reality helmets - manufacture of computer projectors (video beamers) This class also includes: - manufacture of computer terminals, like automatic teller machines (ATM's), point-of-sale (POS) terminals, not mechanically operated - manufacture of multi-function office equipment, such as fax-scanner-copier combinations This class excludes: - reproduction of recorded media (computer media, sound, video, etc.), see 1820 - manufacture of electronic components and electronic assemblies used in computers and peripherals, see 2610 - manufacture of internal/external computer modems, see 2610 - manufacture of interface cards, modules and assemblies, see 2610 - manufacture of modems, carrier equipment, see 2630 - manufacture of digital communication switches, data communications equipment (e.g. bridges, routers, gateways), see 2630 - manufacture of consumer electronic devices, such as CD players and DVD players, see 2640 - manufacture of television monitors and displays, see 2640 - manufacture of video game consoles, see 2640 - manufacture of blank optical and magnetic media for use with computers or other devices, see 2680$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2630, 'Manufacture of communication equipment', $$This class includes the manufacture of telephone and data communications equipment used to move signals electronically over wires or through the air such as radio and television broadcast and wireless communications equipment. This class includes: - manufacture of central office switching equipment - manufacture of cordless telephones - manufacture of private branch exchange (PBX) equipment - manufacture of telephone and facsimile equipment, including telephone answering machines - manufacture of data communications equipment, such as bridges, routers, and gateways - manufacture of transmitting and receiving antenna - manufacture of cable television equipment - manufacture of pagers - manufacture of cellular phones - manufacture of mobile communication equipment - manufacture of radio and television studio and broadcasting equipment, including television cameras - manufacture of modems, carrier equipment - manufacture of burglar and fire alarm systems, sending signals to a control station - manufacture of radio and television transmitters - manufacture of infrared devices (e.g. remote controls) This class excludes: - manufacture of computers and computer peripheral equipment, see 2620 - manufacture of consumer audio and video equipment, see 2640 - manufacture of electronic components and subassemblies used in communications equipment, see 2610 - manufacture of internal/external computer modems (PC-type), see 2610 - manufacture of electronic scoreboards, see 2790 - manufacture of traffic lights, see 2790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2640, 'Manufacture of consumer electronics', $$This class includes the manufacture of electronic audio and video equipment for home entertainment, motor vehicle, public address systems and musical instrument amplification. This class includes: - manufacture of video cassette recorders and duplicating equipment - manufacture of televisions - manufacture of television monitors and displays - manufacture of audio recording and duplicating systems - manufacture of stereo equipment - manufacture of radio receivers - manufacture of speaker systems - manufacture of household-type video cameras - manufacture of jukeboxes - manufacture of amplifiers for musical instruments and public address systems - manufacture of microphones - manufacture of CD and DVD players - manufacture of karaoke machines - manufacture of headphones (e.g. radio, stereo, computer) - manufacture of video game consoles This class excludes: - reproduction of recorded media (computer media, sound, video, etc.), see 1820 - manufacture of computer peripheral devices and computer monitors, see 2620 - manufacture of telephone answering machines, see 2630 - manufacture of paging equipment, see 2630 - manufacture of remote control devices (radio and infrared), see 2630 - manufacture of broadcast studio equipment such as reproduction equipment, transmitting and receiving antennas, commercial video cameras, see 2630 - manufacture of electronic games with fixed (non-replaceable) software, see 3240$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2651, 'Manufacture of measuring, testing, navigating and control equipment', $$This class includes the manufacture of search, detection, navigation, guidance, aeronautical and nautical systems and instruments; automatic controls and regulators for applications, such as heating, air-conditioning, refrigeration and appliances; instruments and devices for measuring, displaying, indicating, recording, transmitting and controlling industrial process variables, such as temperature, humidity, pressure, vacuum, combustion, flow, level, viscosity, density, acidity, concentration and rotation; totalizing (i.e. registering) fluid meters and counting devices; instruments for measuring and testing the characteristics of electricity and electrical signals; instruments and instrumentation systems for laboratory analysis of the chemical or physical composition or concentration of samples of solid, fluid, gaseous or composite material and other measuring and testing instruments and parts thereof. The manufacture of non-electric measuring, testing, navigating and control equipment (except simple mechanical tools) is included here. This class includes: - manufacture of aircraft engine instruments - manufacture of automotive emissions testing equipment - manufacture of meteorological instruments - manufacture of physical properties testing and inspection equipment - manufacture of polygraph machines - manufacture of instruments for measuring and testing electricity and electrical signals (including for telecommunications) - manufacture of radiation detection and monitoring instruments - manufacture of electron and proton microscopes - manufacture of surveying instruments - manufacture of thermometers liquid-in-glass and bimetal types (except medical) - manufacture of humidistats - manufacture of hydronic limit controls - manufacture of flame and burner control - manufacture of spectrometers - manufacture of pneumatic gauges - manufacture of consumption meters (e.g. water, gas) - manufacture of flow meters and counting devices - manufacture of tally counters - manufacture of mine detectors, pulse (signal) generators; metal detectors - manufacture of search, detection, navigation, aeronautical and nautical equipment, including sonobuoys - manufacture of radar equipment - manufacture of GPS devices - manufacture of environmental controls and automatic controls for appliances - manufacture of measuring and recording equipment (e.g. flight recorders) - manufacture of motion detectors - manufacture of laboratory analytical instruments (e.g. blood analysis equipment) - manufacture of laboratory scales, balances, incubators, and miscellaneous laboratory apparatus for measuring, testing, etc. This class excludes: - manufacture of telephone answering machines, see 2630 - manufacture of irradiation equipment, see 2660 - manufacture of optical measuring and checking devices and instruments (e.g. fire control equipment, photographic light meters, range finders), see 2670 - manufacture of optical positioning equipment, see 2670 - manufacture of dictating machines, see 2817 - manufacture of levels, tape measures and similar hand tools, machinists' precision tools, see 2819 - manufacture of medical thermometers, see 3250 - installation of industrial process control equipment, see 3320$$ 
);
INSERT INTO "isic_class" (code,name,description) VALUES (
	2652, 'Manufacture of watches and clocks', $$This class includes the manufacture of watches, clocks and timing mechanisms and parts thereof. This class includes: - manufacture of watches and clocks of all kinds, including instrument panel clocks - manufacture of watch and clock cases, including cases of precious metals - manufacture of time-recording equipment and equipment for measuring, recording and otherwise displaying intervals of time with a watch or clock movement or with synchronous motor, such as: - parking meters - time clocks - time/date stamps - process timers - manufacture of time switches and other releases with a watch or clock movement or with synchronous motor: - time locks - manufacture of components for clocks and watches: - movements of all kinds for watches and clocks - springs, jewels, dials, hands, plates, bridges and other parts This class excludes: - manufacture of non-metal watch bands (textile, leather, plastic), see 1512 - manufacture of watch bands of precious metal, see 3211 - manufacture of watch bands of non-precious metal, see 3212$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2660, 'Manufacture of irradiation, electromedical and electrotherapeutic equipment', $$This class includes: - manufacture of irradiation apparatus and tubes (e.g. industrial, medical diagnostic, medical therapeutic, research, scientific): - beta-, gamma, X-ray or other radiation equipment - manufacture of CT scanners - manufacture of PET scanners - manufacture of magnetic resonance imaging (MRI) equipment - manufacture of medical ultrasound equipment - manufacture of electrocardiographs - manufacture of electromedical endoscopic equipment - manufacture of medical laser equipment - manufacture of pacemakers - manufacture of hearing aids This class also includes: - manufacture of food and milk irradiation equipment This class excludes: - manufacture of laboratory analytical instruments (e.g. blood analysis equipment), see 2651 - manufacture of tanning beds, see 2790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2670, 'Manufacture of optical instruments and photographic equipment', $$This class includes the manufacture of optical instruments and lenses, such as binoculars, microscopes (except electron, proton), telescopes, prisms and lenses (except ophthalmic); the coating or polishing of lenses (except ophthalmic); the mounting of lenses (except ophthalmic) and the manufacture of photographic equipment such as cameras and light meters. This class includes: - manufacture of lenses and prisms - manufacture of optical microscopes, binoculars and telescopes - manufacture of optical mirrors - manufacture of optical magnifying instruments - manufacture of optical machinist's precision tools - manufacture of optical comparators - manufacture of optical gun sighting equipment - manufacture of optical positioning equipment - manufacture of optical measuring and checking devices and instruments (e.g. fire control equipment, photographic light meters, range finders) - manufacture of film cameras and digital cameras - manufacture of motion picture and slide projectors - manufacture of overhead transparency projectors - manufacture of laser assemblies This class also includes: - coating, polishing and mounting of lenses This class excludes: - manufacture of computer projectors, see 2620 - manufacture of commercial TV and video cameras, see 2630 - manufacture of household-type video cameras, see 2640 - manufacture of electron and proton microscopes, see 2651 - manufacture of complete equipment using laser components, see manufacturing class by type of machinery (e.g. medical laser equipment, see 2660) - manufacture of photocopy machinery, see 2817 - manufacture of ophthalmic goods, see 3250$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2680, 'Manufacture of magnetic and optical media', $$This class includes the manufacture of magnetic and optical recording media. This class includes: - manufacture of blank magnetic audio and video tapes - manufacture of blank magnetic audio and video cassettes - manufacture of blank diskettes - manufacture of blank optical discs - manufacture of hard drive media This class excludes: - reproduction of recorded media (computer media, sound, video, etc.), see 1820$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2710, 'Manufacture of electric motors, generators, transformers and electricity distribution and control apparatus', $$This class includes the manufacture of power, distribution and specialty transformers; electric motors, generators and motor generator sets; switchgear and switchboard apparatus; relays and industrial controls. The electrical equipment manufactured in this class is for distribution level voltages. This class includes: - manufacture of distribution transformers, electric - manufacture of arc-welding transformers - manufacture of fluorescent ballasts (i.e. transformers) - manufacture of substation transformers for electric power distribution - manufacture of transmission and distribution voltage regulators - manufacture of electric motors (except internal combustion engine starting motors) - manufacture of power generators (except battery charging alternators for internal combustion engines) - manufacture of motor generator sets (except turbine generator set units) - manufacture of prime mover generator sets - rewinding of armatures on a factory basis - manufacture of power circuit breakers - manufacture of surge suppressors (for distribution level voltage) - manufacture of control panels for electric power distribution - manufacture of electrical relays - manufacture of duct for electrical switchboard apparatus - manufacture of electric fuses - manufacture of power switching equipment - manufacture of electric power switches (except pushbutton, snap, solenoid, tumbler) This class excludes: - manufacture of electronic component-type transformers and switches, see 2610 - manufacture of environmental controls and industrial process control instruments, see 2651 - manufacture of switches for electrical circuits, such as pushbutton and snap switches, see 2733 - manufacture of electric welding and soldering equipment, see 2790 - manufacture of solid state inverters, rectifiers and converters, see 2790 - manufacture of turbine-generator sets, see 2811 - manufacture of starting motors and generators for internal combustion engines, see 2930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2720, 'Manufacture of batteries and accumulators', $$This class includes the manufacture of non-rechargeable and rechargeable batteries. This class includes: - manufacture of primary cells and primary batteries - cells containing manganese dioxide, mercuric dioxide, silver oxide etc. - manufacture of electric accumulators, including parts thereof: - separators, containers, covers - manufacture of lead acid batteries - manufacture of NiCad batteries - manufacture of NiMH batteries - manufacture of lithium batteries - manufacture of dry cell batteries - manufacture of wet cell batteries$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2731, 'Manufacture of fibre optic cables', $$This class includes: - manufacture of fiber optic cable for data transmission or live transmission of images This class excludes: - manufacture of glass fibres or strand, see 2310 - manufacture of optical cable sets or assemblies with connectors or other attachments, see depending on application, e.g. 2610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2732, 'Manufacture of other electronic and electric wires and cables', $$This class includes: - manufacture of insulated wire and cable, made of steel, copper, aluminium This class excludes: - manufacture (drawing) of wire, see 2410, 2420 - manufacture of computer cables, printer cables, USB cables and similar cable sets or assemblies, see 2610 - manufacture of extension cords, see 2790 - manufacture of cable sets, wiring harnesses and similar cable sets or assemblies for automotive applications, see 2930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2733, 'Manufacture of wiring devices', $$This class includes the manufacture of current-carrying and non current-carrying wiring devices for electrical circuits regardless of material. This class includes: - manufacture of bus bars, electrical conductors (except switchgear-type) - manufacture of GFCI (ground fault circuit interrupters) - manufacture of lamp holders - manufacture of lightning arrestors and coils - manufacture of switches for electrical wiring (e.g. pressure, pushbutton, snap, tumbler switches) - manufacture of electrical outlets and sockets - manufacture of boxes for electrical wiring (e.g. junction, outlet, switch boxes) - manufacture of electrical conduit and fitting - manufacture of transmission pole and line hardware - manufacture of plastic non current-carrying wiring devices including plastic junction boxes, face plates, and similar, plastic pole line fittings This class excludes: - manufacture of ceramic insulators, see 2393 - manufacture of electronic component-type connectors, sockets and switches, see 2610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2740, 'Manufacture of electric lighting equipment', $$This class includes the manufacture of electric light bulbs and tubes and parts and components thereof (except glass blanks for electric light bulbs), electric lighting fixtures and lighting fixture components (except current-carrying wiring devices). This class includes: - manufacture of discharge, incandescent, fluorescent, ultra-violet, infra-red etc. lamps, fixtures and bulbs - manufacture of ceiling lighting fixtures - manufacture of chandeliers - manufacture of table lamps (i.e. lighting fixture) - manufacture of Christmas tree lighting sets - manufacture of electric fireplace logs - manufacture of flashlights - manufacture of electric insect lamps - manufacture of lanterns (e.g. carbide, electric, gas, gasoline, kerosene) - manufacture of spotlights - manufacture of street lighting fixtures (except traffic signals) - manufacture of lighting equipment for transportation equipment (e.g. for motor vehicles, aircraft, boats) This class also includes: - manufacture of non-electrical lighting equipment This class excludes: - manufacture of glassware and glass parts for lighting fixtures, see 2310 - manufacture of current-carrying wiring devices for lighting fixtures, see 2733 - manufacture of ceiling fans or bath fans with integrated lighting fixtures, see 2750 - manufacture of electrical signalling equipment such as traffic lights and pedestrian signalling equipment, see 2790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2750, 'Manufacture of domestic appliances', $$This class includes the manufacture of small electric appliances and electric housewares, household-type fans, household-type vacuum cleaners, electric household-type floor care machines, household-type cooking appliances, household-type laundry equipment, household-type refrigerators, upright and chest freezers and other electrical and non-electrical household appliances, such as dishwashers, water heaters and garbage disposal units. This class includes the manufacture of appliances with electric, gas or other fuel sources. This class includes: - manufacture of domestic electric appliances: - refrigerators - freezers - dishwashers - washing and drying machines - vacuum cleaners - floor polishers - waste disposers - grinders, blenders, juice squeezers - tin openers - electric shavers, electric toothbrushes and other electric personal care device - knife sharpeners - ventilating or recycling hoods - manufacture of domestic electrothermic appliances: - electric water heaters - electric blankets - electric dryers, combs, brushes, curlers - electric smoothing irons - space heaters and household-type fans, portable - electric ovens - microwave ovens - cookers, hotplates - toasters - coffee or tea makers - fry pans, roasters, grills, hoods - electric heating resistors etc. - manufacture of domestic non-electric cooking and heating equipment: - non-electric space heaters, cooking ranges, grates, stoves, water heaters, cooking appliances, plate warmers This class excludes: - manufacture of commercial and industrial refrigerators and freezers, room air-conditioners, attic fans, permanent mount space heaters and commercial ventilation and exhaust fans, commercial-type cooking equipment; commercial-type laundry, dry-cleaning and pressing equipment; commercial, industrial and institutional vacuum cleaners, see division 28 - manufacture of household-type sewing machines, see 2826 - installation of central vacuum cleaning systems, 4329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2790, 'Manufacture of other electrical equipment', $$This class includes the manufacture of miscellaneous electrical equipment other than motors, generators and transformers, batteries and accumulators, wires and wiring devices, lighting equipment or domestic appliances. This class includes: - manufacture of battery chargers, solid-state - manufacture of door opening and closing devices, electrical - manufacture of electric bells - manufacture of ultrasonic cleaning machines (except laboratory and dental) - manufacture of tanning beds - manufacture of solid state inverters, rectifying apparatus, fuel cells, regulated and unregulated power supplies - manufacture of uninterruptible power supplies (UPS) - manufacture of surge suppressors (except for distribution level voltage) - manufacture of appliance cords, extension cords, and other electrical cord sets with insulated wire and connectors - manufacture of carbon and graphite electrodes, contacts, and other electrical carbon and graphite products - manufacture of particle accelerators - manufacture of electrical capacitors, resistors, condensers and similar components - manufacture of electromagnets - manufacture of sirens - manufacture of electronic scoreboards - manufacture of electrical signs - manufacture of electrical signalling equipment such as traffic lights and pedestrian signalling equipment - manufacture of electrical insulators (except glass or porcelain) - manufacture of electrical welding and soldering equipment, including hand-held soldering irons This class excludes: - manufacture of non-electrical signs, see class according to material (plastic signs 2220, metal signs 2599) - manufacture of porcelain electrical insulators, see 2393 - manufacture of carbon and graphite fibers and products (except electrodes and electrical applications), see 2399 - manufacture of electronic component-type rectifiers, voltage regulating integrated circuits, power converting integrated circuits, electronic capacitors, electronic resistors and similar devices, see 2610 - manufacture of transformers, motors, generators, switchgear, relays and industrial controls, see 2710 - manufacture of batteries, see 2720 - manufacture of communication and energy wire, current-carrying and non current-carrying wiring devices, see 2733 - manufacture of lighting equipment, see 2740 - manufacture of household-type appliances, see 2750 - manufacture of non-electrical welding and soldering equipment, see 2819 - manufacture of motor vehicle electrical equipment, such as generators, alternators, spark plugs, ignition wiring harnesses, power window and door systems, voltage regulators, see 2930 - manufacture of mechanical and electromechanical signalling, safety and traffic control equipment for railways, tramways, inland waterways, roads, parking facilities, airfields, see 3020$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2811, 'Manufacture of engines and turbines, except aircraft, vehicle and cycle engines', $$This class includes: - manufacture of internal combustion piston engines, except motor vehicle, aircraft and cycle propulsion engines: - marine engines - railway engines - manufacture of pistons, piston rings, carburetors and such for all internal combustion engines, diesel engines etc. - manufacture of inlet and exhaust valves of internal combustion engines - manufacture of turbines and parts thereof: - steam turbines and other vapour turbines - hydraulic turbines, waterwheels and regulators thereof - wind turbines - gas turbines, except turbojets or turbo propellers for aircraft propulsion - manufacture of boiler-turbine sets - manufacture of turbine-generator sets This class excludes: - manufacture of electric generators (except turbine generator sets), see 2710 - manufacture of prime mover generator sets (except turbine generator sets), see 2710 - manufacture of electrical equipment and components of internal combustion engines, see 2790 - manufacture of motor vehicle, aircraft or cycle propulsion engines, see 2910, 3030, 3091 - manufacture of turbojets and turbo propellers, see 3030$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2812, 'Manufacture of fluid power equipment', $$This class includes: - manufacture of hydraulic and pneumatic components (including hydraulic pumps, hydraulic motors, hydraulic and pneumatic cylinders, hydraulic and pneumatic valves, hydraulic and pneumatic hose and fittings) - manufacture of air preparation equipment for use in pneumatic systems - manufacture of fluid power systems - manufacture of hydraulic transmission equipment This class excludes: - manufacture of compressors, see 2813 - manufacture of pumps and valves for non-fluid power applications, see 2813 - manufacture of mechanical transmission equipment, see 2814$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2813, 'Manufacture of other pumps, compressors, taps and valves', $$This class includes: - manufacture of air or vacuum pumps, air or other gas compressors - manufacture of pumps for liquids whether or not fitted with a measuring device - manufacture of pumps designed for fitting to internal combustion engines: oil, water and fuel pumps for motor vehicles etc. This class also includes: - manufacture of industrial taps and valves, including regulating valves and intake taps - manufacture of sanitary taps and valves - manufacture of heating taps and valves - manufacture of hand pumps This class excludes: - manufacture of valves of unhardened vulcanized rubber, glass or of ceramic materials, see 2219, 2310 or 2393 - manufacture of hydraulic transmission equipment, see 2812 - manufacture of inlet and exhaust valves of internal combustion engines, see 2811$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2814, 'Manufacture of bearings, gears, gearing and driving elements', $$This class includes: - manufacture of ball and roller bearings and parts thereof - manufacture of mechanical power transmission equipment: - transmission shafts and cranks: camshafts, crankshafts, cranks etc. - bearing housings and plain shaft bearings - manufacture of gears, gearing and gear boxes and other speed changers - manufacture of clutches and shaft couplings - manufacture of flywheels and pulleys - manufacture of articulated link chain - manufacture of power transmission chain This class excludes: - manufacture of other chain, see 2599 - manufacture of (electromagnetic) clutches, see 2930 - manufacture of sub-assemblies of power transmission equipment identifiable as parts of vehicles or aircraft, see divisions 29 and 30$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	 2815, 'Manufacture of ovens, furnaces and furnace burners', $$This class includes: - manufacture of electrical and other industrial and laboratory furnaces and ovens, including incinerators - manufacture of burners - manufacture of permanent mount electric space heaters, electric swimming pool heaters - manufacture of permanent mount non-electric household heating equipment, such as solar heating, steam heating, oil heat and similar furnaces and heating equipment - manufacture of electric household-type furnaces (electric forced air furnaces, heat pumps, etc.), non-electric household forced air furnaces This class also includes: - manufacture of mechanical stokers, grates, ash dischargers etc. This class excludes: - manufacture of household ovens, see 2750 - manufacture of agricultural dryers, see 2825 - manufacture of bakery ovens, see 2825 - manufacture of dryers for wood, paper pulp, paper or paperboard, see 2829 - manufacture of medical, surgical or laboratory sterilizers, see 3250 - manufacture of (dental) laboratory furnaces, see 3250$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2816, 'Manufacture of lifting and handling equipment', $$This class includes: - manufacture of hand-operated or power-driven lifting, handling, loading or unloading machinery: - pulley tackle and hoists, winches, capstans and jacks - derricks, cranes, mobile lifting frames, straddle carriers etc. - works trucks, whether or not fitted with lifting or handling equipment, whether or not self-propelled, of the type used in factories (including hand trucks and wheelbarrows) - mechanical manipulators and industrial robots specifically designed for lifting, handling, loading or unloading - manufacture of conveyors, telfers (téléphériques) etc. - manufacture of lifts, escalators and moving walkways - manufacture of parts specialized for lifting and handling equipment This class excludes: - manufacture of continuous-action elevators and conveyors for underground use, see 2824 - manufacture of mechanical shovels, excavators and shovel loaders, see 2824 - manufacture of industrial robots for multiple uses, see 2829 - manufacture of crane-lorries, floating cranes, railway cranes, see 2910, 3011, 3020 - installation of lifts and elevators, see 4329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2817, 'Manufacture of office machinery and equipment (except computers and peripheral equipment)', $$This class includes: - manufacture of calculating machines - manufacture of adding machines, cash registers - manufacture of calculators, electronic or not - manufacture of postage meters, mail handling machines (envelope stuffing, sealing and addressing machinery; opening, sorting, scanning), collating machinery - manufacture of typewriters - manufacture of stenography machines - manufacture of office-type binding equipment (i.e. plastic or tape binding) - manufacture of cheque writing machines - manufacture of coin counting and coin wrapping machinery - manufacture of pencil sharpeners - manufacture of staplers and staple removers - manufacture of voting machines - manufacture of tape dispensers - manufacture of hole punches - manufacture of cash registers, mechanically operated - manufacture of photocopy machines - manufacture of toner cartridges - manufacture of blackboards; white boards and marker boards - manufacture of dictating machines This class excludes: - manufacture of computers and peripheral equipment, see 2620$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2818, 'Manufacture of power-driven hand tools', $$This class includes: - manufacture of hand tools, with self-contained electric or non-electric motor or pneumatic drive, such as: - circular or reciprocating saws - drills and hammer drills - hand held power sanders - pneumatic nailers - buffers - routers - grinders - staplers - pneumatic rivet guns - planers - shears and nibblers - impact wrenches - powder actuated nailers This class excludes: - manufacture of electrical hand-held soldering and welding equipment, see 2790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2819, 'Manufacture of other general-purpose machinery', $$This class includes: - manufacture of industrial refrigerating or freezing equipment, including assemblies of major components - manufacture of air-conditioning machines, including for motor vehicles - manufacture of non-domestic fans - manufacture of weighing machinery (other than sensitive laboratory balances): - household and shop scales, platform scales, scales for continuous weighing, weighbridges, weights etc. - manufacture of filtering or purifying machinery and apparatus for liquids - manufacture of equipment for projecting, dispersing or spraying liquids or powders: - spray guns, fire extinguishers, sandblasting machines, steam cleaning machines etc. - manufacture of packing and wrapping machinery: - filling, closing, sealing, capsuling or labeling machines etc. - manufacture of machinery for cleaning or drying bottles and for aerating beverages - manufacture of distilling or rectifying plant for petroleum refineries, chemical industries, beverage industries etc. - manufacture of heat exchangers - manufacture of machinery for liquefying air or gas - manufacture of gas generators - manufacture of calendering or other rolling machines and cylinders thereof (except for metal and glass) - manufacture of centrifuges (except cream separators and clothes dryers) - manufacture of gaskets and similar joints made of a combination of materials or layers of the same material - manufacture of automatic goods vending machines - manufacture of parts for general-purpose machinery - manufacture of attic ventilation fans (gable fans, roof ventilators, etc.) - manufacture of levels, tape measures and similar hand tools, machinists' precision tools (except optical) - manufacture of non-electrical welding and soldering equipment This class excludes: - manufacture of sensitive (laboratory-type) balances, see 2651 - manufacture of domestic refrigerating or freezing equipment, see 2750 - manufacture of domestic fans, see 2750 - manufacture of electrical welding and soldering equipment, see 2790 - manufacture of agricultural spraying machinery, see 2821 - manufacture of metal or glass rolling machinery and cylinders thereof, see 2823, 2829 - manufacture of agricultural dryers, see 2825 - manufacture of machinery for filtering or purifying food, see 2825 - manufacture of cream separators, see 2825 - manufacture of commercial clothes dryers, see 2826 - manufacture of textile printing machinery, see 2826$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2821, 'Manufacture of agricultural and forestry machinery', $$This class includes: - manufacture of tractors used in agriculture and forestry - manufacture of walking (pedestrian-controlled) tractors - manufacture of mowers, including lawnmowers - manufacture of agricultural self-loading or self-unloading trailers or semi-trailers - manufacture of agricultural machinery for soil preparation, planting or fertilizing: - ploughs, manure spreaders, seeders, harrows etc. - manufacture of harvesting or threshing machinery: - harvesters, threshers, sorters etc. - manufacture of milking machines - manufacture of spraying machinery for agricultural use - manufacture of diverse agricultural machinery: - poultry-keeping machinery, bee-keeping machinery, equipment for preparing fodder etc. - machines for cleaning, sorting or grading eggs, fruit etc. This class excludes: - manufacture of non-power-driven agricultural hand tools, see 2593 - manufacture of conveyors for farm use, see 2816 - manufacture of power-driven hand tools, see 2818 - manufacture of cream separators, see 2825 - manufacture of machinery to clean, sort or grade seed, grain or dried leguminous vegetables, see 2825 - manufacture of road tractors for semi-trailers, see 2910 - manufacture of road trailers or semi-trailers, see 2920$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2822, 'Manufacture of metal-forming machinery and machine tools', $$This class includes: - manufacture of machine tools for working metals and other materials (wood, bone, stone, hard rubber, hard plastics, cold glass etc.), including those using a laser beam, ultrasonic waves, plasma arc, magnetic pulse etc. - manufacture of machine tools for turning, drilling, milling, shaping, planing, boring, grinding etc. - manufacture of stamping or pressing machine tools - manufacture of punch presses, hydraulic presses, hydraulic brakes, drop hammers, forging machines etc. - manufacture of draw-benches, thread rollers or machines for working wires - manufacture of stationary machines for nailing, stapling, glueing or otherwise assembling wood, cork, bone, hard rubber or plastics etc. - manufacture of stationary rotary or rotary percussion drills, filing machines, riveters, sheet metal cutters etc. - manufacture of presses for the manufacture of particle board and the like - manufacture of electroplating machinery This class also includes: - manufacture of parts and accessories for the machine tools listed above: work holders, dividing heads and other special attachments for machine tools This class excludes: - manufacture of interchangeable tools for hand tools or machine tools (drills, punches, dies, taps, milling cutters, turning tools, saw blades, cutting knives etc.), see 2593 - manufacture of electric hand held soldering irons and soldering guns, see 2790 - manufacture of power-driven hand tools, see 2818 - manufacture of machinery used in metal mills or foundries, see 2823 - manufacture of machinery for mining and quarrying, see 2824$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2823, 'Manufacture of machinery for metallurgy', $$This class includes: - manufacture of machines and equipment for handling hot metals: - converters, ingot moulds, ladles, casting machines - manufacture of metal-rolling mills and rolls for such mills This class excludes: - manufacture of draw-benches, see 2822 - manufacture of moulding boxes and moulds (except ingot moulds), see 2593 - manufacture of machines for forming foundry moulds, see 2829$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2824, 'Manufacture of machinery for mining, quarrying and construction', $$This class includes: - manufacture of continuous-action elevators and conveyors for underground use - manufacture of boring, cutting, sinking and tunnelling machinery (whether or not for underground use) - manufacture of machinery for treating minerals by screening, sorting, separating, washing, crushing etc. - manufacture of concrete and mortar mixers - manufacture of earth-moving machinery: - bulldozers, angle-dozers, graders, scrapers, levellers, mechanical shovels, shovel loaders etc. - manufacture of pile drivers and pile extractors, mortar spreaders, bitumen spreaders, concrete surfacing machinery etc. - manufacture of tracklaying tractors and tractors used in construction or mining - manufacture of bulldozer and angle-dozer blades - manufacture of off-road dumping trucks This class excludes: - manufacture of lifting and handling equipment, see 2816 - manufacture of other tractors, see 2821, 2910 - manufacture of machine tools for working stone, including machines for splitting or clearing stone, see 2822 - manufacture of concrete-mixer lorries, see 2910 - manufacture of mining locomotives and mining rail cars, see 3020$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2825, 'Manufacture of machinery for food, beverage and tobacco processing', $$This class includes: - manufacture of agricultural dryers - manufacture of machinery for the dairy industry: - cream separators - milk processing machinery (e.g. homogenizers) - milk converting machinery (e.g. butter chums, butter workers and moulding machines) - cheese-making machines (e.g. homogenizers, moulders, presses) etc. - manufacture of machinery for the grain milling industry: - machinery to clean, sort or grade seeds, grain or dried leguminous vegetables (winnowers, sieving belts, separators, grain brushing machines etc.) - machinery to produce flour and meal etc. (grinding mills, feeders, sifters, bran cleaners, blenders, rice hullers, pea splitters) - manufacture of presses, crushers etc. used to make wine, cider, fruit juices etc. - manufacture of machinery for the bakery industry or for making macaroni, spaghetti or similar products: - bakery ovens, dough mixers, dough-dividers, moulders, slicers, cake depositing machines etc. - manufacture of machines and equipment to process diverse foods: - machinery to make confectionery, cocoa or chocolate; to manufacture sugar; for breweries; to process meat or poultry; to prepare fruit, nuts or vegetables; to prepare fish, shellfish or other seafood - machinery for filtering and purifying - other machinery for the industrial preparation or manufacture of food or drink - manufacture of machinery for the extraction or preparation of animal or vegetable fats or oils - manufacture of machinery for the preparation of tobacco and for the making of cigarettes or cigars, or for pipe or chewing tobacco or snuff - manufacture of machinery for the preparation of food in hotels and restaurants This class excludes: - manufacture of food and milk irradiation equipment, see 2660 - manufacture of packing, wrapping and weighing machinery, see 2819 - manufacture of cleaning, sorting or grading machinery for eggs, fruit or other crops (except seeds, grains and dried leguminous vegetables), see 2821$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2826, 'Manufacture of machinery for textile, apparel and leather production', $$This class includes: - manufacture of textile machinery: - machines for preparing, producing, extruding, drawing, texturing or cutting man-made textile fibres, materials or yarns - machines for preparing textile fibres: cotton gins, bale breakers, garnetters, cotton spreaders, wool scourers, wool carbonizers, combs, carders, roving frames etc. - spinning machines - machines for preparing textile yarns: reelers, warpers and related machines - weaving machines (looms), including hand looms - knitting machines - machines for making knotted net, tulle, lace, braid etc. - manufacture of auxiliary machines or equipment for textile machinery: - dobbies, jacquards, automatic stop motions, shuttle changing mechanisms, spindles and spindle flyers etc. - manufacture of textile printing machinery - manufacture of machinery for fabric processing: - machinery for washing, bleaching, dyeing, dressing, finishing, coating or impregnating textile fabrics - manufacture of machines for reeling, unreeling, folding, cutting or pinking textile fabrics - manufacture of laundry machinery: - ironing machines, including fusing presses - commercial washing and drying machines - dry-cleaning machines - manufacture of sewing machines, sewing machine heads and sewing machine needles (whether or not for household use) - manufacture of machines for producing or finishing felt or non-wovens - manufacture of leather machines: - machinery for preparing, tanning or working hides, skins or leather - machinery for making or repairing footwear or other articles of hides, skins, leather or fur skins This class excludes: - manufacture of paper or paperboard cards for use on jacquard machines, see 1709 - manufacture of domestic washing and drying machines, see 2750 - manufacture of calendering machines, see 2819 - manufacture of machines used in bookbinding, see 2829$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2829, 'Manufacture of other special-purpose machinery', $$This class includes the manufacture of special-purpose machinery not elsewhere classified. This class includes: - manufacture of machinery for making paper pulp - manufacture of paper and paperboard making machinery - manufacture of dryers for wood, paper pulp, paper or paperboard - manufacture of machinery producing articles of paper or paperboard - manufacture of machinery for working soft rubber or plastics or for the manufacture of products of these materials: - extruders, moulders, pneumatic tyre making or retreading machines and other machines for making a specific rubber or plastic product - manufacture of printing and bookbinding machines and machines for activities supporting printing on a variety of materials - manufacture of machinery for producing tiles, bricks, shaped ceramic pastes, pipes, graphite electrodes, blackboard chalk, foundry moulds etc. - manufacture of semi-conductor manufacturing machinery - manufacture of industrial robots performing multiple tasks for special purposes - manufacture of diverse special-purpose machinery and equipment: - machines to assemble electric or electronic lamps, tubes (valves) or bulbs - machines for production or hot-working of glass or glassware, glass fibre or yarn - machinery or apparatus for isotopic separation - manufacture of tire alignment and balancing equipment; balancing equipment (except wheel balancing) - manufacture of central greasing systems - manufacture of aircraft launching gear, aircraft carrier catapults and related equipment - manufacture of automatic bowling alley equipment (e.g. pin-setters) - manufacture of roundabouts, swings, shooting galleries and other fairground amusements This class excludes: - manufacture of household appliances, see 2750 - manufacture of photocopy machines etc., see 2817 - manufacture of machinery or equipment to work hard rubber, hard plastics or cold glass, see 2822 - manufacture of ingot moulds, see 2823 - manufacture of textile printing machinery, see 2826$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2910, 'Manufacture of motor vehicles', $$This class includes: - manufacture of passenger cars - manufacture of commercial vehicles: - vans, lorries, over-the-road tractors for semi-trailers etc. - manufacture of buses, trolley-buses and coaches - manufacture of motor vehicle engines - manufacture of chassis fitted with engines - manufacture of other motor vehicles: - snowmobiles, golf carts, amphibious vehicles - fire engines, street sweepers, travelling libraries, armoured cars etc. - concrete-mixer lorries - ATVs, go-carts and similar including race cars This class also includes: - factory rebuilding of motor vehicle engines This class excludes: - manufacture of lighting equipment for motor vehicles, see 2740 - manufacture of pistons, piston rings and carburetors, see 2811 - manufacture of agricultural tractors, see 2821 - manufacture of tractors used in construction or mining, see 2824 - manufacture of off-road dumping trucks, see 2824 - manufacture of bodies for motor vehicles, see 2920 - manufacture of electrical parts for motor vehicles, see 2930 - manufacture of parts and accessories for motor vehicles, see 2930 - manufacture of tanks and other military fighting vehicles, see 3040 - maintenance, repair and alteration of motor vehicles, see 4520$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2920, 'Manufacture of bodies (coachwork) for motor vehicles; manufacture of trailers and semi-trailers', $$This class includes: - manufacture of bodies, including cabs for motor vehicles - outfitting of all types of motor vehicles, trailers and semi-trailers - manufacture of trailers and semi-trailers: - for transport of goods: tankers, removal trailers etc. - for transport of passengers: caravan trailers etc. - manufacture of containers for carriage by one or more modes of transport This class excludes: - manufacture of trailers and semi-trailers specially designed for use in agriculture, see 2821 - manufacture of parts and accessories of bodies for motor vehicles, see 2930 - manufacture of vehicles drawn by animals, see 3099$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	2930, 'Manufacture of parts and accessories for motor vehicles', $$This class includes: - manufacture of diverse parts and accessories for motor vehicles: - brakes, gearboxes, axles, road wheels, suspension shock absorbers, radiators, silencers, exhaust pipes, catalytic converters, clutches, steering wheels, steering columns and steering boxes - manufacture of parts and accessories of bodies for motor vehicles: - safety belts, airbags, doors, bumpers - manufacture of car seats - manufacture of motor vehicle electrical equipment, such as generators, alternators, spark plugs, ignition wiring harnesses, power window and door systems, assembly of purchased gauges into instrument panels, voltage regulators, etc. This class excludes: - manufacture of tyres, see 2211 - manufacture of rubber hoses and belts and other rubber products, see 2219 - manufacture of plastic hoses and belts and other plastic products, see 2220 - manufacture of batteries for vehicles, see 2720 - manufacture of lighting equipment for motor vehicles, see 2740 - manufacture of pistons, piston rings and carburetors, see 2811 - manufacture of pumps for motor vehicles and engines, see 2813 - maintenance, repair and alteration of motor vehicles, see 4520$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3011, 'Building of ships and floating structures', $$This class includes the building of ships, except vessels for sports or recreation, and the construction of floating structures. This class includes: - building of commercial vessels: - passenger vessels, ferry boats, cargo ships, tankers, tugs etc. - building of warships - building of fishing boats and fish-processing factory vessels This class also includes: - building of hovercraft (except recreation-type hovercraft) - construction of drilling platforms, floating or submersible - construction of floating structures: - floating docks, pontoons, coffer-dams, floating landing stages, buoys, floating tanks, barges, lighters, floating cranes, non-recreational inflatable rafts etc. - manufacture of sections for ships and floating structures This class excludes: - manufacture of parts of vessels, other than major hull assemblies: - manufacture of sails, see 1392 - manufacture of ships' propellers, see 2599 - manufacture of iron or steel anchors, see 2599 - manufacture of marine engines, see 2811 - manufacture of navigational instruments, see 2651 - manufacture of lighting equipment for ships, see 2740 - manufacture of amphibious motor vehicles, see 2910 - manufacture of inflatable boats or rafts for recreation, see 3012 - specialized repair and maintenance of ships and floating structures, see 3315 - ship-breaking, see 3830 - interior installation of boats, see 4330$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3012, 'Building of pleasure and sporting boats', $$This class includes: - manufacture of inflatable boats and rafts - building of sailboats with or without auxiliary motor - building of motor boats - building of recreation-type hovercraft - manufacture of personal watercraft - manufacture of other pleasure and sporting boats: - canoes, kayaks, rowing boats, skiffs This class excludes: - manufacture of parts of pleasure and sporting boats: - manufacture of sails, see 1392 - manufacture of iron or steel anchors, see 2599 - manufacture of marine engines, see 2811 - manufacture of sailboards and surfboards, see 3230 - maintenance, repair or alteration of pleasure boats, see 3315$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3020, 'Manufacture of railway locomotives and rolling stock', $$This class includes: - manufacture of electric, diesel, steam and other rail locomotives - manufacture of self-propelled railway or tramway coaches, vans and trucks, maintenance or service vehicles - manufacture of railway or tramway rolling stock, not self-propelled: - passenger coaches, goods vans, tank wagons, self-discharging vans and wagons, workshop vans, crane vans, tenders etc. - manufacture of specialized parts of railway or tramway locomotives or of rolling stock: - bogies, axles and wheels, brakes and parts of brakes; hooks and coupling devices, buffers and buffer parts; shock absorbers; wagon and locomotive frames; bodies; corridor connections etc. This class also includes: - manufacture of mechanical and electromechanical signalling, safety and traffic control equipment for railways, tramways, inland waterways, roads, parking facilities, airfields etc. - manufacture of mining locomotives and mining rail cars - manufacture of railway car seats This class excludes: - manufacture of unassembled rails, see 2410 - manufacture of assembled railway track fixtures, see 2599 - manufacture of electric motors, see 2710 - manufacture of electrical signalling, safety or traffic-control equipment, see 2790 - manufacture of engines and turbines, see 2811$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3030, 'Manufacture of air and spacecraft and related machinery', $$This class includes: - manufacture of airplanes for the transport of goods or passengers, for use by the defence forces, for sport or other purposes - manufacture of helicopters - manufacture of gliders, hang-gliders - manufacture of dirigibles and hot air balloons - manufacture of parts and accessories of the aircraft of this class: - major assemblies such as fuselages, wings, doors, control surfaces, landing gear, fuel tanks, nacelles etc. - airscrews, helicopter rotors and propelled rotor blades - motors and engines of a kind typically found on aircraft - parts of turbojets and turboprops for aircraft - manufacture of ground flying trainers - manufacture of spacecraft and launch vehicles, satellites, planetary probes, orbital stations, shuttles - manufacture of intercontinental ballistic missiles (ICBM) This class also includes: - overhaul and conversion of aircraft or aircraft engines - manufacture of aircraft seats This class excludes: - manufacture of parachutes, see 1392 - manufacture of military ordinance and ammunition, see 2520 - manufacture of telecommunication equipment for satellites, see 2630 - manufacture of aircraft instrumentation and aeronautical instruments, see 2651 - manufacture of air navigation systems, see 2651 - manufacture of lighting equipment for aircraft, see 2740 - manufacture of ignition parts and other electrical parts for internal combustion engines, see 2790 - manufacture of pistons, piston rings and carburetors, see 2811 - manufacture of aircraft launching gear, aircraft carrier catapults and related equipment, see 2829$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3040, 'Manufacture of military fighting vehicles', $$This class includes: - manufacture of tanks - manufacture of armored amphibious military vehicles - manufacture of other military fighting vehicles This class excludes: - manufacture of weapons and ammunitions, see 2520$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3091, 'Manufacture of motorcycles', $$This class includes: - manufacture of motorcycles, mopeds and cycles fitted with an auxiliary engine - manufacture of engines for motorcycles - manufacture of sidecars - manufacture of parts and accessories for motorcycles This class excludes: - manufacture of bicycles, see 3092 - manufacture of invalid carriages, see 3092$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3092, 'Manufacture of bicycles and invalid carriages', $$This class includes: - manufacture of non-motorized bicycles and other cycles, including (delivery) tricycles, tandems, children's bicycles and tricycles - manufacture of parts and accessories of bicycles - manufacture of invalid carriages with or without motor - manufacture of parts and accessories of invalid carriages - manufacture of baby carriages This class excludes: - manufacture of bicycles with auxiliary motor, see 3091 - manufacture of wheeled toys designed to be ridden, including plastic bicycles and tricycles, see 3240$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3099, 'Manufacture of other transport equipment n.e.c.', $$This class includes: - manufacture of hand-propelled vehicles: luggage trucks, handcarts, sledges, shopping carts etc. - manufacture of vehicles drawn by animals: sulkies, donkey-carts, hearses etc. This class excludes: - works trucks, whether or not fitted with lifting or handling equipment, whether or not self-propelled, of the type used in factories (including hand trucks and wheelbarrows), see 2816 - decorative restaurant carts, such as a desert cart, food wagons, see 3100$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3100,'Manufacture of furniture', $$This class includes the manufacture of furniture of any kind, any material (except stone, concrete or ceramic) for any place and various purposes. This class includes: - manufacture of chairs and seats for offices, workrooms, hotels, restaurants, public and domestic premises - manufacture of chairs and seats for theatres, cinemas and the like - manufacture of sofas, sofa beds and sofa sets - manufacture of garden chairs and seats - manufacture of special furniture for shops: counters, display cases, shelves etc. - manufacture of furniture for churches, schools, restaurants - manufacture of office furniture - manufacture of kitchen furniture - manufacture of furniture for bedrooms, living rooms, gardens etc. - manufacture of cabinets for sewing machines, televisions etc. - manufacture of laboratory benches, stools and other laboratory seating, laboratory furniture (e.g. cabinets and tables) This class also includes: - finishing such as upholstery of chairs and seats - finishing of furniture such as spraying, painting, French polishing and upholstering - manufacture of mattress supports - manufacture of mattresses: - mattresses fitted with springs or stuffed or internally fitted with a supporting material - uncovered cellular rubber or plastic mattresses - decorative restaurant carts, such as dessert carts, food wagons This class excludes: - manufacture of pillows, pouffes, cushions, quilts and eiderdowns, see 1392 - manufacture of inflatable rubber mattresses, see 2219 - manufacture of furniture of ceramics, concrete and stone, see 2393, 2395, 2396 - manufacture of lighting fittings or lamps, see 2740 - blackboards, see 2817 - manufacture of car seats, railway seats, aircraft seats, see 2930, 3020, 3030 - modular furniture attachment and installation, partition installation, laboratory equipment furniture installation, see 4330$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3211,'Manufacture of jewellery and related articles', $$This class includes: - production of worked pearls - production of precious and semi-precious stones in the worked state, including the working of industrial quality stones and synthetic or reconstructed precious or semi-precious stones - working of diamonds - manufacture of jewellery of precious metal or of base metals clad with precious metals, or precious or semi-precious stones, or of combinations of precious metal and precious or semi-precious stones or of other materials - manufacture of goldsmiths' articles of precious metals or of base metals clad with precious metals: - dinnerware, flatware, hollowware, toilet articles, office or desk articles, articles for religious use etc. - manufacture of technical or laboratory articles of precious metal (except instruments and parts thereof): crucibles, spatulas, electroplating anodes etc. - manufacture of precious metal watch bands, wristbands, watch straps and cigarette cases - manufacture of coins, including coins for use as legal tender, whether or not of precious metal This class also includes: - engraving of personal precious and non-precious metal products This class excludes: - manufacture of non-metal watch bands (fabric, leather, plastic etc.), see 1512 - manufacture of articles of base metal plated with precious metal (except imitation jewellery), see division 25 - manufacture of watchcases, see 2652 - manufacture of (non-precious) metal watch bands, see 3212 - manufacture of imitation jewellery, see 3212$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3212,'Manufacture of imitation jewellery and related articles', $$This class includes: - manufacture of costume or imitation jewellery: - rings, bracelets, necklaces, and similar articles of jewellery made from base metals plated with precious metals - jewellery containing imitation stones such as imitation gems stones, imitation diamonds, and similar - manufacture of metal watch bands (except precious metal) This class excludes: - manufacture of jewellery made from precious metals or clad with precious metals, see 3211 - manufacture of jewellery containing genuine gem stones, see 3211 - manufacture of precious metal watch bands, see 3211$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3220,'Manufacture of musical instruments', $$This class includes: - manufacture of stringed instruments - manufacture of keyboard stringed instruments, including automatic pianos - manufacture of keyboard pipe organs, including harmoniums and similar keyboard instruments with free metal reeds - manufacture of accordions and similar instruments, including mouth organs - manufacture of wind instruments - manufacture of percussion musical instruments - manufacture of musical instruments, the sound of which is produced electronically - manufacture of musical boxes, fairground organs, calliopes etc. - manufacture of instrument parts and accessories: - metronomes, tuning forks, pitch pipes, cards, discs and rolls for automatic mechanical instruments etc. This class also includes: - manufacture of whistles, call horns and other mouth-blown sound signalling instruments This class excludes: - reproduction of pre-recorded sound and video tapes and discs, see 1820 - manufacture of microphones, amplifiers, loudspeakers, headphones and similar components, see 2640 - manufacture of record players, tape recorders and the like, see 2640 - manufacture of toy musical instruments, see 3240 - restoring of organs and other historic musical instruments, see 3319 - publishing of pre-recorded sound and video tapes and discs, see 5920 - piano tuning, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3230,'Manufacture of sports goods', $$This class includes the manufacture of sporting and athletic goods (except apparel and footwear). This class includes: - manufacture of articles and equipment for sports, outdoor and indoor games, of any material: - hard, soft and inflatable balls - rackets, bats and clubs - skis, bindings and poles - ski-boots - sailboards and surfboards - requisites for sport fishing, including landing nets - requisites for hunting, mountain climbing etc. - leather sports gloves and sports headgear - ice skates, roller skates etc. - bows and crossbows - gymnasium, fitness centre or athletic equipment This class excludes: - manufacture of boat sails, see 1392 - manufacture of sports apparel, see 1410 - manufacture of saddlery and harness, see 1512 - manufacture of whips and riding crops, see 1512 - manufacture of sports footwear, see 1520 - manufacture of sporting weapons and ammunition, see 2520 - manufacture of metal weights as used for weightlifting, see 2599 - manufacture of automatic bowling alley equipment (e.g. pin-setters), see 2829 - manufacture of sports vehicles other than toboggans and the like, see divisions 29 and 30 - manufacture of boats, see 3012 - manufacture of billiard tables, see 3240 - manufacture of ear and noise plugs (e.g. for swimming and noise protection), see 3290$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3240,'Manufacture of games and toys', $$This class includes the manufacture of dolls, toys and games (including electronic games), scale models and children's vehicles (except metal bicycles and tricycles). This class includes: - manufacture of dolls and doll garments, parts and accessories - manufacture of action figures - manufacture of toy animals - manufacture of toy musical instruments - manufacture of playing cards - manufacture of board games and similar games - manufacture of electronic games: chess etc. - manufacture of reduced-size ("scale") models and similar recreational models, electrical trains, construction sets etc. - manufacture of coin-operated games, billiards, special tables for casino games, etc. - manufacture of articles for funfair, table or parlour games - manufacture of wheeled toys designed to be ridden, including plastic bicycles and tricycles - manufacture of puzzles and similar articles This class excludes: - manufacture of video game consoles, see 2640 - manufacture of bicycles, see 3092 - writing and publishing of software for video game consoles, see 5820, 6201$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3250,'Manufacture of medical and dental instruments and supplies', $$This class includes the manufacture of laboratory apparatus, surgical and medical instruments, surgical appliances and supplies, dental equipment and supplies, orthodontic goods, dentures and orthodontic appliances. Included is the manufacture of medical, dental and similar furniture, where the additional specific functions determine the purpose of the product, such as dentist's chairs with built-in hydraulic functions. This class includes: - manufacture of surgical drapes and sterile string and tissue - manufacture of dental fillings and cements (except denture adhesives), dental wax and other dental plaster preparations - manufacture of bone reconstruction cements - manufacture of dental laboratory furnaces - manufacture of laboratory ultrasonic cleaning machinery - manufacture of laboratory sterilizers - manufacture of laboratory type distilling apparatus, laboratory centrifuges - manufacture of medical, surgical, dental or veterinary furniture, such as: - operating tables - examination tables - hospital beds with mechanical fittings - dentists' chairs - manufacture of bone plates and screws, syringes, needles, catheters, cannulae, etc. - manufacture of dental instruments (including dentists' chairs incorporating dental equipment) - manufacture of artificial teeth, bridges, etc., made in dental labs - manufacture of orthopedic and prosthetic devices - manufacture of glass eyes - manufacture of medical thermometers - manufacture of ophthalmic goods, eyeglasses, sunglasses, lenses ground to prescription, contact lenses, safety goggles This class excludes: - manufacture of denture adhesives, see 2023 - manufacture of medical impregnated wadding, dressings etc., see 2100 - manufacture of electromedical and electrotherapeutic equipment, see 2660 - manufacture of wheelchairs, see 3092$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3290,'Other manufacturing n.e.c.', $$This class includes: - manufacture of protective safety equipment - manufacture of fire-resistant and protective safety clothing - manufacture of linemen's safety belts and other belts for occupational use - manufacture of cork life preservers - manufacture of plastics hard hats and other personal safety equipment of plastics (e.g. athletic helmets) - manufacture of fire-fighting protection suits - manufacture of metal safety headgear and other metal personal safety devices - manufacture of ear and noise plugs (e.g. for swimming and noise protection) - manufacture of gas masks - manufacture of brooms and brushes, including brushes constituting parts of machines, hand-operated mechanical floor sweepers, mops and feather dusters, paint brushes, paint pads and rollers, squeegees and other brushes, brooms, mops etc. - manufacture of shoe and clothes brushes - manufacture of pens and pencils of all kinds whether or not mechanical - manufacture of pencil leads - manufacture of date, sealing or numbering stamps, hand-operated devices for printing, or embossing labels, hand printing sets, prepared typewriter ribbons and inked pads - manufacture of globes - manufacture of umbrellas, sun-umbrellas, walking sticks, seat-sticks - manufacture of buttons, press-fasteners, snap-fasteners, press-studs, slide fasteners - manufacture of cigarette lighters - manufacture of articles of personal use: smoking pipes, scent sprays, vacuum flasks and other vacuum vessels for personal or household use, wigs, false beards, eyebrows - manufacture of miscellaneous articles: candles, tapers and the like; bouquets, wreaths and floral baskets; artificial flowers, fruit and foliage; jokes and novelties; hand sieves and hand riddles; tailors' dummies; burial caskets etc. - taxidermy activities This class excludes: - manufacture of lighter wicks, see 1399 - manufacture of workwear and service apparel (e.g. laboratory coats, work overalls, uniforms), see 1410 - manufacture of paper novelties, see 1709 - manufacture of plastic novelties, see 2220$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3311, 'Repair of fabricated metal products', $$This class includes the repair and maintenance of fabricated metal products of division 25. This class includes: - repair of metal tanks, reservoirs and containers - repair and maintenance for pipes and pipelines - mobile welding repair - repair of steel shipping drums - repair and maintenance of steam or other vapour generators - repair and maintenance of auxiliary plant for use with steam generators: - condensers, economizers, superheaters, steam collectors and accumulators - repair and maintenance of nuclear reactors, except isotope separators - repair and maintenance of parts for marine or power boilers - platework repair of central heating boilers and radiators - repair and maintenance of fire arms and ordnance (including repair of sporting and recreational guns) This class excludes: - repair of central heating systems etc., see 4322 - repair of mechanical locking devices, safes etc., see 8020$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3312, 'Repair of machinery', $$This class includes the repair and maintenance of industrial machinery and equipment like sharpening or installing commercial and industrial machinery blades and saws; the provision of welding (e.g. automotive, general) repair services; the repair of agricultural and other heavy and industrial machinery and equipment (e.g. forklifts and other materials handling equipment, machine tools, commercial refrigeration equipment, construction equipment and mining machinery), comprising machinery and equipment of division 28. This class includes: - repair and maintenance of non-automotive engines, e.g. ship or rail engines - repair and maintenance of pumps and related equipment - repair and maintenance of fluid power equipment - repair of valves - repair of gearing and driving elements - repair and maintenance of industrial process furnaces - repair and maintenance of materials handling equipment - repair and maintenance of commercial refrigeration equipment and air purifying equipment - repair and maintenance of commercial-type general-purpose machinery - repair of other power-driven hand-tools - repair and maintenance of metal cutting and metal forming machine tools and accessories - repair and maintenance of other machine tools - repair and maintenance of agricultural tractors - repair and maintenance of agricultural machinery and forestry and logging machinery - repair and maintenance of metallurgy machinery - repair and maintenance of mining, construction, and oil and gas field machinery - repair and maintenance of food, beverage, and tobacco processing machinery - repair and maintenance of textile apparel, and leather production machinery - repair and maintenance of papermaking machinery - repair and maintenance of other special-purpose machinery of division 28 - repair and maintenance of weighing equipment - repair and maintenance of vending machines - repair and maintenance of cash registers - repair and maintenance of photocopy machines - repair of calculators, electronic or not - repair of typewriters This class excludes: - installation, repair and maintenance of furnaces and other heating equipment, see 4322 - installation, repair and maintenance of elevators and escalators, see 4329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3313, 'Repair of electronic and optical equipment', $$This class includes the repair and maintenance of goods produced in groups 265, 266 and 267, except those that are considered household goods. This class includes: - repair and maintenance of the measuring, testing, navigating and control equipment of group 265, such as: - aircraft engine instruments - automotive emissions testing equipment - meteorological instruments - physical, electrical and chemical properties testing and inspection equipment - surveying instruments - radiation detection and monitoring instruments - repair and maintenance of irradiation, electromedical and electrotherapeutic equipment of class 2660, such as: - magnetic resonance imaging equipment - medical ultrasound equipment - pacemakers - hearing aids - electrocardiographs - electromedical endoscopic equipment - irradiation apparatus - repair and maintenance of optical instruments and equipment of class 2670, if the use is mainly commercial, such as: - binoculars - microscopes (except electron and proton microscopes) - telescopes - prisms and lenses (except ophthalmic) - photographic equipment This class excludes: - repair and maintenance of photocopy machines, see 3312 - repair and maintenance of computers and peripheral equipment, see 9511 - repair and maintenance of computer projectors, see 9511 - repair and maintenance of communication equipment, see 9512 - repair and maintenance of commercial TV and video cameras, see 9512 - repair of household-type video cameras, see 9521 - repair of watches and clocks, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3314, 'Repair of electrical equipment', $$This class includes the repair and maintenance of goods of division 27, except those in class 2750 (domestic appliances). This class includes: - repair and maintenance of power, distribution, and specialty transformers - repair and maintenance of electric motors, generators, and motor generator sets - repair and maintenance of switchgear and switchboard apparatus - repair and maintenance of relays and industrial controls - repair and maintenance of primary and storage batteries - repair and maintenance of electric lighting equipment - repair and maintenance of current-carrying wiring devices and non current-carrying wiring devices for wiring electrical circuits This class excludes: - repair and maintenance of computers and peripheral computer equipment, see 9511 - repair and maintenance of telecommunications equipment, see 9512 - repair and maintenance of consumer electronics, see 9521 - repair of watches and clocks, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3315, 'Repair of transport equipment, except motor vehicles', $$This class includes the repair and maintenance of transport equipment of division 30, except motorcycles and bicycles. However, the factory rebuilding or overhaul of ships, locomotives, railroad cars and aircraft is classified in division 30. This class includes: - repair and routine maintenance of ships - repair and maintenance of pleasure boats - repair and maintenance of locomotives and railroad cars (except factory rebuilding or factory conversion) - repair and maintenance of aircraft (except factory conversion, factory overhaul, factory rebuilding) - repair and maintenance of aircraft engines - repair of animal drawn buggies and wagons This class excludes: - factory rebuilding of ships, see 3011 - factory rebuilding of locomotives and railroad cars, see 3020 - factory rebuilding of aircraft, see 3030 - repair of ship or rail engines, see 3312 - ship scaling, dismantling, see 3830 - repair and maintenance of motorcycles, see 4540 - repair of bicycles and invalid carriages, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3319, 'Repair of other equipment', $$This class includes the repair and maintenance of equipment not covered in other groups of this division. This class includes: - repair of fishing nets, including mending - repair or ropes, riggings, canvas and tarps - repair of fertilizer and chemical storage bags - repair or reconditioning of wooden pallets, shipping drums or barrels, and similar items - repair of pinball machines and other coin-operated games - restoring of organs and other historical musical instruments This class excludes: - repair of household and office type furniture, furniture restoration, see 9524 - repair of bicycles and invalid carriages, see 9529 - repair and alteration of clothing, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3320, 'Installation of industrial machinery and equipment', $$This class includes the specialized installation of machinery. However, the installation of equipment that forms an integral part of buildings or similar structures, such as installation of escalators, electrical wiring, burglar alarm systems or air-conditioning systems, is classified as construction. This class includes: - installation of industrial machinery in industrial plant - installation of industrial process control equipment - installation of other industrial equipment, e.g.: - communications equipment - mainframe and similar computers - irradiation and electromedical equipment etc. - dismantling large-scale machinery and equipment - activities of millwrights - machine rigging - installation of bowling alley equipment This class excludes: - installation of electrical wiring, burglar alarm systems, see 4321 - installation of air-conditioning systems, see 4322 - installation of elevators, escalators, automated doors, vacuum cleaning systems etc., see 4329 - installation of doors, staircases, shop fittings, furniture etc., see 4330 - installation (setting-up) of personal computers, see 6209$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3510, 'Electric power generation, transmission and distribution', $$This class includes the generation of bulk electric power, transmission from generating facilities to distribution centers and distribution to end users. This class includes: - operation of generation facilities that produce electric energy, including thermal, nuclear, hydroelectric, gas turbine, diesel and renewable - operation of transmission systems that convey the electricity from the generation facility to the distribution system - operation of distribution systems (i.e. consisting of lines, poles, meters, and wiring) that convey electric power received from the generation facility or the transmission system to the final consumer - sale of electricity to the user - activities of electric power brokers or agents that arrange the sale of electricity via power distribution systems operated by others - operation of electricity and transmission capacity exchanges for electric power This class excludes: - production of electricity through incineration of waste, see 3821$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3520, 'Manufacture of gas; distribution of gaseous fuels through mains', $$This class includes the manufacture of gas and the distribution of natural or synthetic gas to the consumer through a system of mains. Gas marketers or brokers, which arrange the sale of natural gas over distribution systems operated by others, are included. The separate operation of gas pipelines, typically done over long distances, connecting producers with distributors of gas, or between urban centers, is excluded from this class and classified with other pipeline transport activities. This class includes: - production of gas for the purpose of gas supply by carbonation of coal, from by-products of agriculture or from waste - manufacture of gaseous fuels with a specified calorific value, by purification, blending and other processes from gases of various types including natural gas - transportation, distribution and supply of gaseous fuels of all kinds through a system of mains - sale of gas to the user through mains - activities of gas brokers or agents that arrange the sale of gas over gas distribution systems operated by others - commodity and transport capacity exchanges for gaseous fuels This class excludes: - operation of coke ovens, see 1910 - manufacture of refined petroleum products, see 1920 - manufacture of industrial gases, see 2011 - wholesale of gaseous fuels, see 4661 - retail sale of bottled gas, see 4773 - direct selling of fuel, see 4799 - (long-distance) transportation of gases by pipelines, see 4930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3530,'Steam and air conditioning supply', $$This class includes: - production, collection and distribution of steam and hot water for heating, power and other purposes - production and distribution of cooled air - production and distribution of chilled water for cooling purposes - production of ice, including ice for food and non-food (e.g. cooling) purposes$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3600,'Water collection, treatment and supply', $$This class includes water collection, treatment and distribution activities for domestic and industrial needs. Collection of water from various sources, as well as distribution by various means is included. The operation of irrigation canals is also included; however the provision of irrigation services through sprinklers, and similar agricultural support services, is not included. This class includes: - collection of water from rivers, lakes, wells etc. - collection of rain water - purification of water for water supply purposes - treatment of water for industrial and other purposes - desalting of sea or ground water to produce water as the principal product of interest - distribution of water through mains, by trucks or other means - operation of irrigation canals This class excludes: - operation of irrigation equipment for agricultural purposes, see 0161 - treatment of wastewater in order to prevent pollution, see 3700 - (long-distance) transport of water via pipelines, see 4930$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3700,'Sewerage', $$This class includes: - operation of sewer systems or sewer treatment facilities - collecting and transporting of human or industrial wastewater from one or several users, as well as rain water by means of sewerage networks, collectors, tanks and other means of transport (sewage vehicles etc.) - emptying and cleaning of cesspools and septic tanks, sinks and pits from sewage; servicing of chemical toilets - treatment of wastewater (including human and industrial wastewater, water from swimming pools etc.) by means of physical, chemical and biological processes like dilution, screening, filtering, sedimentation etc. - maintenance and cleaning of sewers and drains, including sewer rodding$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3811,'Collection of non-hazardous waste', $$This class includes: - collection of non-hazardous solid waste (i.e. garbage) within a local area, such as collection of waste from households and businesses by means of refuse bins, wheeled bins, containers etc may include mixed recoverable materials - collection of recyclable materials - collection of used cooking oils and fats - collection of refuse in litter-bins in public places This class also includes: - collection of construction and demolition waste - collection and removal of debris such as brush and rubble - collection of waste output of textile mills - operation of waste transfer stations for non-hazardous waste This class excludes: - collection of hazardous waste, see 3812 - operation of landfills for the disposal of non-hazardous waste, see 3821 - operation of facilities where commingled recoverable materials such as paper, plastics, etc. are sorted into distinct categories, see 3830$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3812,'Collection of hazardous waste', $$This class includes the collection of solid and non-solid hazardous waste, i.e. explosive, oxidizing, flammable, toxic, irritant, carcinogenic, corrosive, infectious and other substances and preparations harmful for human health and environment. It may also entail identification, treatment, packaging and labeling of waste for the purposes of transport. This class includes: - collection of hazardous waste, such as: - used oil from shipment or garages - bio-hazardous waste - used batteries - operation of waste transfer stations for hazardous waste This class excludes: - remediation and clean up of contaminated buildings, mine sites, soil, ground water, e.g. asbestos removal, see 3900$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3821,'Treatment and disposal of non-hazardous waste', $$This class includes the disposal, treatment prior to disposal and other treatment of solid or non-solid non-hazardous waste. This class includes: - operation of landfills for the disposal of non-hazardous waste - disposal of non-hazardous waste by combustion or incineration or other methods, with or without the resulting production of electricity or steam, substitute fuels, biogas, ashes or other by-products for further use etc. - treatment of organic waste for disposal - production of compost from organic waste This class excludes: - incineration and combustion of hazardous waste, see 3822 - operation of facilities where commingled recoverable materials such as paper, plastics, used beverage cans and metals, are sorted into distinct categories, see 3830 - decontamination, clean up of land, water; toxic material abatement, see 3900$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3822,'Treatment and disposal of hazardous waste', $$This class includes the disposal and treatment prior to disposal of solid or non-solid hazardous waste, including waste that is explosive, oxidizing, flammable, toxic, irritant, carcinogenic, corrosive or infectious and other substances and preparations harmful for human health and environment. This class includes: - operation of facilities for treatment of hazardous waste - treatment and disposal of toxic live or dead animals and other contaminated waste - incineration of hazardous waste - disposal of used goods such as refrigerators to eliminate harmful waste - treatment, disposal and storage of radioactive nuclear waste including: - treatment and disposal of transition radioactive waste, i.e. decaying within the period of transport, from hospitals - encapsulation, preparation and other treatment of nuclear waste for storage This class excludes: - incineration of non-hazardous waste, see 3821 - decontamination, clean up of land, water; toxic material abatement, see 3900 - reprocessing of nuclear fuels, see 2011$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3830,'Materials recovery', $$This class includes: - processing of metal and non-metal waste and scrap and other articles into secondary raw materials, usually involving a mechanical or chemical transformation process - recovery of materials from waste streams in the form of: - separating and sorting recoverable materials from non-hazardous waste streams (i.e. garbage) - separating and sorting of commingled recoverable materials, such as paper, plastics, used beverage cans and metals, into distinct categories Examples of the mechanical or chemical transformation processes that are undertaken are: - mechanical crushing of metal waste such as used cars, washing machines, bikes etc. with subsequent sorting and separation - dismantling of automobiles, computers, televisions and other equipment for materials recovery - mechanical reduction of large iron pieces such as railway wagons - shredding of metal waste, end-of-life vehicles etc. - other methods of mechanical treatment as cutting, pressing to reduce the volume - ship-breaking - reclaiming metals out of photographic waste, e.g. fixer solution or photographic films and paper - reclaiming of rubber such as used tires to produce secondary raw material - sorting and pelleting of plastics to produce secondary raw material for tubes, flower pots, pallets and the like - processing (cleaning, melting, grinding) of plastic or rubber waste to granulates - crushing, cleaning and sorting of glass - crushing, cleaning and sorting of other waste such as demolition waste to obtain secondary raw material - processing of used cooking oils and fats into secondary raw materials - processing of other food, beverage and tobacco waste and residual substances into secondary raw materials This class excludes: - manufacture of new final products from (whether or not self-produced) secondary raw materials, such as spinning yarn from garnetted stock, making pulp from paper waste, retreading tyres or production of metal from metal scrap, see corresponding classes in section C (Manufacturing) - reprocessing of nuclear fuels, see 2011 - remelting ferrous waste and scrap, see 2410 - treatment and disposal of non-hazardous waste, see 3821 - treatment of organic waste for disposal, see 3821 - energy recovery from non-hazardous waste incineration processes, see 3821 - disposal of used goods such as refrigerators to eliminate harmful waste, see 3822 - treatment and disposal of transition radioactive waste from hospitals etc., see 3822 - treatment and disposal of toxic, contaminated waste, see 3822 - dismantling of automobiles, computers, televisions and other equipment to obtain and re-sell usable parts, see section G - wholesale of recoverable materials, see 4669$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	3900,'Remediation activities and other waste management services', $$This class includes: - decontamination of soils and groundwater at the place of pollution, either in situ or ex situ, using e.g. mechanical, chemical or biological methods - decontamination of industrial plants or sites, including nuclear plants and sites - decontamination and cleaning up of surface water following accidental pollution, e.g. through collection of pollutants or through application of chemicals - cleaning up of oil spills and other pollutions on land, in surface water, in ocean and seas, including coastal areas - asbestos, lead paint, and other toxic material abatement - clearing of landmines and the like (including detonation) - other specialized pollution-control activities This class excludes: - treatment and disposal of non-hazardous waste, see 3821 - treatment and disposal of hazardous waste, see 3822 - outdoor sweeping and watering of streets etc., see 8129$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4100,'Construction of buildings', $$This class includes the construction of complete residential or non-residential buildings, on own account for sale or on a fee or contract basis. Outsourcing parts or even the whole construction process is possible. If only specialized parts of the construction process are carried out, the activity is classified in division 43. This class includes: - construction of all types of residential buildings: - single-family houses - multi-family buildings, including high-rise buildings - construction of all types of non-residential buildings: - buildings for industrial production, e.g. factories, workshops, assembly plants etc. - hospitals, schools, office buildings - hotels, stores, shopping malls, restaurants - airport buildings - indoor sports facilities - parking garages, including underground parking garages - warehouses - religious buildings - assembly and erection of prefabricated constructions on the site This class also includes: - remodeling or renovating existing residential structures This class excludes: - erection of complete prefabricated constructions from self-manufactured parts not of concrete, see divisions 16 and 25 - construction of industrial facilities, except buildings, see 4290 - architectural and engineering activities, see 7110 - project management activities related to construction, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4210,'Construction of roads and railways', $$This class includes: - construction of motorways, streets, roads, other vehicular and pedestrian ways - surface work on streets, roads, highways, bridges or tunnels: - asphalt paving of roads - road painting and other marking - installation of crash barriers, traffic signs and the like - construction of bridges, including those for elevated highways - construction of tunnels - construction of railways and subways - construction of airfield runways This class excludes: - installation of street lighting and electrical signals, see 4321 - architectural and engineering activities, see 7110 - project management activities related to civil engineering works, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4220,'Construction of utility projects', $$This class includes the construction of distribution lines and related buildings and structures that are integral part of these systems. This class includes: - construction of civil engineering constructions for: - long-distance pipelines, communication and power lines - urban pipelines, urban communication and power lines; ancillary urban works - water main and line construction - irrigation systems (canals) - reservoirs - construction of: - sewer systems, including repair - sewage disposal plants - pumping stations - power plants This class also includes: - water well drilling This class excludes: - project management activities related to civil engineering works, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4290,'Construction of other civil engineering projects', $$This class includes: - construction of industrial facilities, except buildings, such as: - refineries - chemical plants - construction of: - waterways, harbour and river works, pleasure ports (marinas), locks, etc. - dams and dykes - dredging of waterways - construction work, other than buildings, such as: - outdoor sports facilities This class also includes: - land subdivision with land improvement (e.g. adding of roads, utility infrastructure etc.) This class excludes: - project management activities related to civil engineering works, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4311,'Demolition', $$This class includes: - demolition or wrecking of buildings and other structures$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4312,'Site preparation', $$This class includes the preparation of sites for subsequent construction activities. This class includes: - clearing of building sites - earth moving: excavation, landfill, levelling and grading of construction sites, trench digging, rock removal, blasting, etc. - drilling, boring and core sampling for construction, geophysical, geological or similar purposes This class also includes: - site preparation for mining: - overburden removal and other development and preparation of mineral properties and sites, except oil and gas sites - building site drainage - drainage of agricultural or forestry land This class excludes: - drilling of production oil or gas wells, see 0610, 0620 - test drilling and test hole boring for mining operations (other than oil and gas extraction), see 0990 - decontamination of soil, see 3900 - water well drilling, see 4220 - shaft sinking, see 4390 - oil and gas field exploration, geophysical, geological and seismic surveying, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4321,'Electrical installation', $$This class includes the installation of electrical systems in all kinds of buildings and civil engineering structures. This class includes: - installation of: - electrical wiring and fittings - telecommunications wiring - computer network and cable television wiring, including fibre optic - satellite dishes - lighting systems - fire alarms - burglar alarm systems - street lighting and electrical signals - airport runway lighting This class also includes: - connecting of electric appliances and household equipment, including baseboard heating This class excludes: - construction of communications and power transmission lines, see 4220 - monitoring or remote monitoring of electronic security alarm systems, such as burglar and fire alarms, including their maintenance, see 8020$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4322,'Plumbing, heat and air-conditioning installation', $$This class includes the installation of plumbing, heating and air-conditioning systems, including additions, alterations, maintenance and repair. This class includes: - installation in buildings or other construction projects of: - heating systems (electric, gas and oil) - furnaces, cooling towers - non-electric solar energy collectors - plumbing and sanitary equipment - ventilation, refrigeration or air-conditioning equipment and ducts - gas fittings - steam piping - fire sprinkler systems - lawn sprinkler systems - duct work installation This class excludes: - installation of electric baseboard heating, see 4321$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4329,'Other construction installation', $$This class includes the installation of equipment other than electrical, plumbing, heating and air-conditioning systems or industrial machinery in buildings and civil engineering structures, including maintenance and repair. This class includes: - installation in buildings or other construction projects of: - elevators, escalators - automated and revolving doors - lightning conductors - vacuum cleaning systems - thermal, sound or vibration insulation This class excludes: - installation of industrial machinery, see 3320$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4330,'Building completion and finishing', $$This class includes: - application in buildings or other construction projects of interior and exterior plaster or stucco, including related lathing materials - installation of doors (except automated and revolving), windows, door and window frames, of wood or other materials - installation of fitted kitchens, staircases, shop fittings and the like - installation of furniture - interior completion such as ceilings, wooden wall coverings, movable partitions, etc. - laying, tiling, hanging or fitting in buildings or other construction projects of: - ceramic, concrete or cut stone wall or floor tiles, ceramic stove fitting - parquet and other wooden floor coverings - carpets and linoleum floor coverings, including of rubber or plastic - terrazzo, marble, granite or slate floor or wall coverings - wallpaper - interior and exterior painting of buildings - painting of civil engineering structures - installation of glass, mirrors, etc. - cleaning of new buildings after construction - other building completion work n.e.c. This class also includes: - interior installation of shops, mobile homes, boats etc. This class excludes: - painting of roads, see 4210 - installation of automated and revolving doors, see 4329 - general interior cleaning of buildings and other structures, see 8121 - specialized interior and exterior cleaning of buildings, see 8129 - activities of interior decoration designers, see 7410 - assembly of self-standing furniture, see 9524$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4390,'Other specialized construction activities', $$This class includes: - construction activities specializing in one aspect common to different kind of structures, requiring specialized skill or equipment: - construction of foundations, including pile driving - damp proofing and water proofing works - de-humidification of buildings - shaft sinking - erection of non-self-manufactured steel elements - steel bending - bricklaying and stone setting - roof covering for residential buildings - scaffolds and work platform erecting and dismantling, excluding renting of scaffolds and work platforms - erection of chimneys and industrial ovens - work with specialist access requirements necessitating climbing skills and the use of related equipment, e.g. working at height on tall structures - subsurface work - construction of outdoor swimming pools - steam cleaning, sand blasting and similar activities for building exteriors - renting of cranes with operator This class excludes: - renting of construction machinery and equipment without operator, see 7730$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4510,'Sale of motor vehicles', $$This class includes: - wholesale and retail sale of new and used vehicles: - passenger motor vehicles, including specialized passenger motor vehicles such as ambulances and minibuses, etc. - lorries, trailers and semi-trailers - camping vehicles such as caravans and motor homes This class also includes: - wholesale and retail sale of off-road motor vehicles (jeeps, etc.) - wholesale and retail sale by commission agents - car auctions This class excludes: - wholesale and retail sale of parts and accessories for motor vehicles, see 4530 - renting of motor vehicles with driver, see 4922 - renting of trucks with driver, see 4923 - renting of motor vehicles and trucks without driver, see 7710$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4520,'Maintenance and repair of motor vehicles', $$This class includes: - maintenance and repair of motor vehicles: - mechanical repairs - electrical repairs - electronic injection systems repair - ordinary servicing - bodywork repair - repair of motor vehicle parts - washing, polishing, etc. - spraying and painting - repair of screens and windows - repair of motor vehicle seats - tyre and tube repair, fitting or replacement - anti-rust treatment - installation of parts and accessories not as part of the manufacturing process This class excludes: - retreading and rebuilding of tyres, see 2211$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4530,'Sale of motor vehicle parts and accessories', $$This class includes: - wholesale and retail sale of all kinds of parts, components, supplies, tools and accessories for motor vehicles, such as: - rubber tires and inner tubes for tires - spark plugs, batteries, lighting equipment and electrical parts This class excludes: - retail sale of automotive fuel, see 4730$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4540,'Sale, maintenance and repair of motorcycles and related parts and accessories', $$- wholesale and retail sale of motorcycles, including mopeds - wholesale and retail sale of parts and accessories for motorcycles (including by commission agents and mail order houses) - maintenance and repair of motorcycles This class excludes: - wholesale of bicycles and related parts and accessories, see 4649 - retail sale of bicycles and related parts and accessories, see 4763 - renting of motorcycles, see 7730 - repair and maintenance of bicycles, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4610,'Wholesale on a fee or contract basis', $$This class includes: - activities of commission agents and all other wholesalers who trade on behalf and on the account of others - activities of those involved in bringing sellers and buyers together or undertaking commercial transactions on behalf of a principal, including on the internet - such agents involved in the sale of: - agricultural raw materials, live animals, textile raw materials and semi-finished goods - fuels, ores, metals and industrial chemicals, including fertilizers - food, beverages and tobacco - textiles, clothing, fur, footwear and leather goods - timber and building materials - machinery, including office machinery and computers, industrial equipment, ships and aircraft - furniture, household goods and hardware This class also includes: - activities of wholesale auctioneering houses This class excludes: - wholesale trade in own name, see groups 462 to 469 - activities of commission agents for motor vehicles, see 4510 - auctions of motor vehicles, see 4510 - retail sale by non-store commission agents, see 4799 - activities of insurance agents, see 6622 - activities of real estate agents, see 6820$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4620,'Wholesale of agricultural raw materials and live animals', $$This class includes: - wholesale of grains and seeds - wholesale of oleaginous fruits - wholesale of flowers and plants - wholesale of unmanufactured tobacco - wholesale of live animals - wholesale of hides and skins - wholesale of leather - wholesale of agricultural material, waste, residues and by-products used for animal feed This class excludes: - wholesale of textile fibres, see 4669$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4630,'Wholesale of food, beverages and tobacco', $$This class includes: - wholesale of fruit and vegetables - wholesale of dairy products - wholesale of eggs and egg products - wholesale of edible oils and fats of animal or vegetable origin - wholesale of meat and meat products - wholesale of fishery products - wholesale of sugar, chocolate and sugar confectionery - wholesale of bakery products - wholesale of beverages - wholesale of coffee, tea, cocoa and spices - wholesale of tobacco products This class also includes: - buying of wine in bulk and bottling without transformation - wholesale of feed for pet animals This class excludes: - blending of wine or distilled spirits, see 1101, 1102$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4641,'Wholesale of textiles, clothing and footwear', $$This class includes: - wholesale of yarn - wholesale of fabrics - wholesale of household linen etc. - wholesale of haberdashery: needles, sewing thread etc. - wholesale of clothing, including sports clothes - wholesale of clothing accessories such as gloves, ties and braces - wholesale of footwear - wholesale of fur articles - wholesale of umbrellas This class excludes: - wholesale of jewellery and leather goods, see 4649 - wholesale of textile fibres, see 4669$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4649,'Wholesale of other household goods', $$This class includes: - wholesale of household furniture - wholesale of household appliances - wholesale of consumer electronics: - radio and TV equipment - CD and DVD players and recorders - stereo equipment - video game consoles - wholesale of lighting equipment - wholesale of cutlery - wholesale of china and glassware - wholesale of woodenware, wickerwork and corkware etc. - wholesale of pharmaceutical and medical goods - wholesale of perfumeries, cosmetics and soaps - wholesale of bicycles and their parts and accessories - wholesale of stationery, books, magazines and newspapers - wholesale of photographic and optical goods (e.g. sunglasses, binoculars, magnifying glasses) - wholesale of recorded audio and video tapes, CDs, DVDs - wholesale of leather goods and travel accessories - wholesale of watches, clocks and jewellery - wholesale of musical instruments, games and toys, sports goods This class excludes: - wholesale of blank audio and video tapes, CDs, DVDs, see 4652 - wholesale of radio and TV broadcasting equipment, see 4652 - wholesale of office furniture, see 4659$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4651,'Wholesale of computers, computer peripheral equipment and software', $$This class includes: - wholesale of computers and computer peripheral equipment - wholesale of software This class excludes: - wholesale of electronic parts, see 4652 - wholesale of office machinery and equipment, (except computers and peripheral equipment), see 4659 - wholesale of computer-controlled machinery, see 4659$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4652,'Wholesale of electronic and telecommunications equipment and parts', $$This class includes: - wholesale of electronic valves and tubes - wholesale of semiconductor devices - wholesale of microchips and integrated circuits - wholesale of printed circuits - wholesale of blank audio and video tapes and diskettes, magnetic and optical disks (CDs, DVDs) - wholesale of telephone and communications equipment This class excludes: - wholesale of recorded audio and video tapes, CDs, DVDs, see 4649 - wholesale of consumer electronics, see 4649 - wholesale of computers and computer peripheral equipment, see 4651$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4653,'Wholesale of agricultural machinery, equipment and supplies', $$This class includes: - wholesale of agricultural machinery and equipment: - ploughs, manure spreaders, seeders - harvesters - threshers - milking machines - poultry-keeping machines, bee-keeping machines - tractors used in agriculture and forestry This class also includes: - lawn mowers however operated$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4659,'Wholesale of other machinery and equipment', $$This class includes: - wholesale of office machinery and equipment, except computers and computer peripheral equipment - wholesale of office furniture - wholesale of transport equipment except motor vehicles, motorcycles and bicycles - wholesale of production-line robots - wholesale of wires and switches and other installation equipment for industrial use - wholesale of other electrical material such as electrical motors, transformers - wholesale of machine tools of any type and for any material - wholesale of other machinery n.e.c. for use in industry, trade and navigation and other services This class also includes: - wholesale of computer-controlled machine tools - wholesale of computer-controlled machinery for the textile industry and of computer-controlled sewing and knitting machines - wholesale of measuring instruments and equipment This class excludes: - wholesale of motor vehicles, trailers and caravans, see 4510 - wholesale of motor vehicle parts, see 4530 - wholesale of motorcycles, see 4540 - wholesale of bicycles, see 4649 - wholesale of computers and peripheral equipment, see 4651 - wholesale of electronic parts and telephone and communications equipment, see 4652$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4661,'Wholesale of solid, liquid and gaseous fuels and related products', $$This class includes: - wholesale of fuels, greases, lubricants, oils such as: - charcoal, coal, coke, fuel wood, naphtha - crude petroleum, crude oil, diesel fuel, gasoline, fuel oil, heating oil, kerosene - liquefied petroleum gases, butane and propane gas - lubricating oils and greases, refined petroleum products$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4662,'Wholesale of metals and metal ores', $$This class includes: - wholesale of grains and seeds - wholesale of oleaginous fruits - wholesale of flowers and plants - wholesale of unmanufactured tobacco - wholesale of live animals - wholesale of hides and skins - wholesale of leather - wholesale of agricultural material, waste, residues and by-products used for animal feed This class excludes: - wholesale of textile fibres, see 4669$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4663,'Wholesale of construction materials, hardware, plumbing and heating equipment and supplies', $$This class includes: - wholesale of fruit and vegetables - wholesale of dairy products - wholesale of eggs and egg products - wholesale of edible oils and fats of animal or vegetable origin - wholesale of meat and meat products - wholesale of fishery products - wholesale of sugar, chocolate and sugar confectionery - wholesale of bakery products - wholesale of beverages - wholesale of coffee, tea, cocoa and spices - wholesale of tobacco products This class also includes: - buying of wine in bulk and bottling without transformation - wholesale of feed for pet animals This class excludes: - blending of wine or distilled spirits, see 1101, 1102$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4669,'Wholesale of waste and scrap and other products n.e.c.', $$This class includes: - wholesale of a variety of goods without any particular specialization$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4711,'Retail sale in non-specialized stores with food, beverages or tobacco predominating', $$This class includes: - retail sale of a large variety of goods of which, however, food products, beverages or tobacco should be predominant, such as: - retail sale activities of general stores that have, apart from their main sales of food products, beverages or tobacco, several other types of goods such as wearing apparel, furniture, appliances, hardware, cosmetics etc. This class excludes: - retail sale of fuel in combination with food, beverages etc., with fuel sales dominating, see 4730$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4719,'Other retail sale in non-specialized stores', $$This class includes: - retail sale of a large variety of goods of which food products, beverages or tobacco are not predominant, such as: - retail sale activities of department stores carrying a general line of goods, including wearing apparel, furniture, appliances, hardware, cosmetics, jewellery, toys, sports goods etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4721,'Retail sale of food in specialized stores', $$This class includes: - retail sale of any the following types of goods: - fresh or preserved fruit and vegetables - dairy products and eggs - meat and meat products (including poultry) - fish, other seafood and products thereof - bakery products - sugar confectionery - other food products This class excludes: - manufacturing of bakery products, i.e. baking on premises, see 1071$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4722,'Retail sale of beverages in specialized stores', $$This class includes: - retail sale of beverages (not for consumption on the premises): - alcoholic beverages - non-alcoholic beverages$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4723,'Retail sale of tobacco products in specialized stores', $$This class includes: - retail sale of tobacco - retail sale of tobacco products$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4730,'Retail sale of automotive fuel in specialized stores', $$This class includes: - retail sale of fuel for motor vehicles and motorcycles This class also includes: - retail sale of lubricating products and cooling products for motor vehicles This class excludes: - wholesale of fuels, see 4661 - retail sale of fuel in combination with food, beverages etc., with food and beverage sales dominating, see 4711 - retail sale of liquefied petroleum gas for cooking or heating, see 4773$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4741,'Retail sale of computers, peripheral units, software and telecommunications equipment in specialized stores', $$This class includes: - retail sale of computers - retail sale of computer peripheral equipment - retail sale of video game consoles - retail sale of non-customized software, including video games - retail sale of telecommunication equipment This class excludes: - retail sale of blank tapes and disks, see 4762$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4742,'Retail sale of audio and video equipment in specialized stores', $$This class includes: - retail sale of radio and television equipment - retail sale of stereo equipment - retail sale of CD and DVD players and recorders$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4751,'Retail sale of textiles in specialized stores', $$This class includes: - retail sale of fabrics - retail sale of knitting yarn - retail sale of basic materials for rug, tapestry or embroidery making - retail sale of textiles - retail sale of haberdashery: needles, sewing thread etc. This class excludes: - retail sale of clothing, see 4771$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4752,'Retail sale of hardware, paints and glass in specialized stores', $$This class includes: - retail sale of hardware - retail sale of paints, varnishes and lacquers - retail sale of flat glass - retail sale of other building material such as bricks, wood, sanitary equipment - retail sale of do-it-yourself material and equipment This class also includes: - retail sale of lawnmowers, however operated - retail sale of saunas$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4753,'Retail sale of carpets, rugs, wall and floor coverings in specialized stores', $$This class includes: - retail sale of carpets and rugs - retail sale of curtains and net curtains - retail sale of wallpaper and floor coverings This class excludes: - retail sale of cork floor tiles, see 4752$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4759,'Retail sale of electrical household appliances, furniture, lighting equipment and other household articles in specialized stores', $$This class includes: - retail sale of household furniture - retail sale of articles for lighting - retail sale of household utensils and cutlery, crockery, glassware, china and pottery - retail sale of wooden, cork and wickerwork goods - retail sale of household appliances - retail sale of musical instruments and scores - retail sale of security systems, such as locking devices, safes, and vaults, without installation or maintenance services - retail sale of household articles and equipment n.e.c. This class excludes: - retail sale of antiques, see 4774$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4761,'Retail sale of books, newspapers and stationary in specialized stores', $$This class includes: - retail sale of books of all kinds - retail sale of newspapers and stationery This class also includes: - retail sale of office supplies such as pens, pencils, paper etc. This class excludes: - retail sale of second-hand or antique books, see 4774$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4762,'Retail sale of music and video recordings in specialized stores', $$This class includes: - retail sale of musical records, audio tapes, compact discs and cassettes - retail sale of video tapes and DVDs This class also includes: - retail sale of blank tapes and discs$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4763,'Retail sale of sporting equipment in specialized stores', $$This class includes: - retail sale of sports goods, fishing gear, camping goods, boats and bicycles$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4764,'Retail sale of games and toys in specialized stores', $$This class includes: - retail sale of games and toys, made of all materials This class excludes: - retail sale of video game consoles, see 4741 - retail sale of non-customized software, including video games, see 4741$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4771,'Retail sale of clothing, footwear and leather articles in specialized stores', $$This class includes: - retail sale of articles of clothing - retail sale of articles of fur - retail sale of clothing accessories such as gloves, ties, braces etc. - retail sale of umbrellas - retail sale of footwear - retail sale of leather goods - retail sale of travel accessories of leather and leather substitutes This class excludes: - retail sale of textiles, see 4751$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4772,'Retail sale of pharmaceutical and medical goods, cosmetic and toilet articles in specialized stores', $$This class includes: - retail sale of pharmaceuticals - retail sale of medical and orthopaedic goods - retail sale of perfumery and cosmetic articles$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4773,'Other retail sale of new goods in specialized stores', $$This class includes: - retail sale of photographic, optical and precision equipment - activities of opticians - retail sale of watches, clocks and jewellery - retail sale of flowers, plants, seeds, fertilizers, pet animals and pet food - retail sale of souvenirs, craftwork and religious articles - activities of commercial art galleries - retail sale of household fuel oil, bottled gas, coal and fuel wood - retail sale of cleaning materials - retail sale of weapons and ammunition - retail sale of stamps and coins - retail sale of non-food products n.e.c.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4774,'Retail sale of second-hand goods', $$This class includes: - retail sale of second-hand books - retail sale of other second-hand goods - retail sale of antiques - activities of auctioning houses (retail) This class excludes: - retail sale of second-hand motor vehicles, see 4510 - activities of Internet auctions and other non-store auctions (retail), see 4791, 4799 - activities of pawn shops, see 6492$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4781,'Retail sale via stalls and markets of food, beverages and tobacco products', $$This class includes: - retail sale of food, beverages and tobacco products via stalls or markets This class excludes: - retail sale of prepared food for immediate consumption (mobile food vendors), see 5610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4782,'Retail sale via stalls and markets of textiles, clothing and footwear', $$This class includes: - retail sale of textiles, clothing and footwear via stalls or markets$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4789,'Retail sale via stalls and markets of other goods', $$This class includes: - retail sale of other goods via stalls or markets, such as: - carpets and rugs - books - games and toys - household appliances and consumer electronics - music and video recordings$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4791,'Retail sale via mail order houses or via Internet', $$This class includes retail sale activities via mail order houses or via Internet, i.e. retail sale activities where the buyer makes his choice on the basis of advertisements, catalogues, information provided on a website, models or any other means of advertising and places his order by mail, phone or over the Internet (usually through special means provided by a website). The products purchased can be either directly downloaded from the Internet or physically delivered to the customer. This class includes: - retail sale of any kind of product by mail order - retail sale of any kind of product over the Internet This class also includes: - direct sale via television, radio and telephone - Internet retail auctions$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4799,'Other retail sale not in stores, stalls or markets', $$This class includes: - retail sale of any kind of product in any way that is not included in previous classes: - by direct sales or door-to-door sales persons - through vending machines etc. - direct selling of fuel (heating oil, fire wood etc.), delivered directly to the customers premises - activities of non-store auctions (retail) - retail sale by (non-store) commission agents This class excludes: - delivery of products by stores, see groups 471-477$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4911,'Passenger rail transport, interurban', $$This class includes: - passenger transport by inter-urban railways - operation of sleeping cars or dining cars as an integrated operation of railway companies This class excludes: - passenger transport by urban and suburban transit systems, see 4921 - passenger terminal activities, see 5221 - operation of sleeping cars or dining cars when operated by separate units, see 5590, 5610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4912,'Freight rail transport', $$This class includes: - freight transport on mainline rail networks as well as short-line freight railroads This class excludes: - storage and warehousing, see 5210 - freight terminal activities, see 5221 - cargo handling, see 5224$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4921,'Urban and suburban passenger land transport', $$This class includes: - land transport of passengers by urban or suburban transport systems. This may include different modes of land transport, such as by motorbus, tramway, streetcar, trolley bus, underground and elevated railways etc. The transport is carried out on scheduled routes normally following a fixed time schedule, entailing the picking up and setting down of passengers at normally fixed stops. This class also includes: - town-to-airport or town-to-station lines - operation of funicular railways, aerial cableways etc. if part of urban or suburban transit systems This class excludes: - passenger transport by inter-urban railways, see 4911$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4922,'Other passenger land transport', $$This class includes: - other passenger road transport: - scheduled long-distance bus services - charters, excursions and other occasional coach services - taxi operation - airport shuttles - operation of telfers (téléphériques), funiculars, ski and cable lifts if not part of urban or suburban transit systems This class also includes: - other renting of private cars with driver - operation of school buses and buses for transport of employees - passenger transport by man- or animal-drawn vehicles This class excludes: - ambulance transport, see 8690$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4923,'Freight transport by road', $$This class includes: - all freight transport operations by road: - logging haulage - stock haulage - refrigerated haulage - heavy haulage - bulk haulage, including haulage in tanker trucks - haulage of automobiles - transport of waste and waste materials, without collection or disposal This class also includes: - furniture removal - renting of trucks with driver - freight transport by man or animal-drawn vehicles This class excludes: - log hauling within the forest, as part of logging operations, see 0240 - distribution of water by trucks, see 3600 - operation of terminal facilities for handling freight, see 5221 - crating and packing services for transport, see 5229 - post and courier activities, see 5310, 5320 - waste transport as integrated part of waste collection activities, see 3811, 3812$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	4930,'Transport via pipeline', $$This class includes: - transport of gases, liquids, water, slurry and other commodities via pipelines This class also includes: - operation of pump stations This class excludes: - distribution of natural or manufactured gas, water or steam, see 3520, 3530, 3600 - transport of water, liquids etc. by trucks, see 4923$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5011,'Sea and coastal passenger water transport', $$This class includes: - transport of passengers over seas and coastal waters, whether scheduled or not: - operation of excursion, cruise or sightseeing boats - operation of ferries, water taxis etc. This class also includes: - renting of pleasure boats with crew for sea and coastal water transport (e.g. for fishing cruises) This class excludes: - restaurant and bar activities on board ships, when provided by separate units, see 5610, 5630 - operation of "floating casinos", see 9200$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5012,'Sea and coastal freight water transport', $$This class includes: - transport of freight over seas and coastal waters, whether scheduled or not - transport by towing or pushing of barges, oil rigs etc. This class excludes: - storage of freight, see 5210 - harbour operation and other auxiliary activities such as docking, pilotage, lighterage, vessel salvage, see 5222 - cargo handling, see 5224$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5021,'Inland passenger water transport', $$This class includes: - transport of passenger via rivers, canals, lakes and other inland waterways, including inside harbours and ports This class also includes: - renting of pleasure boats with crew for inland water transport$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5022,'Inland freight water transport', $$This class includes: - transport of freight via rivers, canals, lakes and other inland waterways, including inside harbours and ports$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5110,'Passenger air transport', $$This class includes: - transport of passengers by air over regular routes and on regular schedules - charter flights for passengers - scenic and sightseeing flights This class also includes: - renting of air-transport equipment with operator for the purpose of passenger transportation - general aviation activities, such as: - transport of passengers by aero clubs for instruction or pleasure$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5120,'Freight air transport', $$This class includes: - transport freight by air over regular routes and on regular schedules - non-scheduled transport of freight by air - launching of satellites and space vehicles - space transport This class also includes: - renting of air-transport equipment with operator for the purpose of freight transportation$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5210,'Warehousing and storage', $$This class includes: - operation of storage and warehouse facilities for all kind of goods: - operation of grain silos, general merchandise warehouses, refrigerated warehouses, storage tanks etc. This class also includes: - storage of goods in foreign trade zones - blast freezing This class excludes: - parking facilities for motor vehicles, see 5221 - operation of self storage facilities, see 6810 - renting of vacant space, see 6810$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5221,'Service activities incidental to land transportation', $$This class includes: - activities related to land transport of passengers, animals or freight: - operation of terminal facilities such as railway stations, bus stations, stations for the handling of goods - operation of railroad infrastructure - operation of roads, bridges, tunnels, car parks or garages, bicycle parkings - switching and shunting - towing and road side assistance This class also includes: - liquefaction of gas for transportation purposes This class excludes: - cargo handling, see 5224$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5222,'Service activities incidental to water transportation', $$This class includes: - activities related to water transport of passengers, animals or freight: - operation of terminal facilities such as harbours and piers - operation of waterway locks etc. - navigation, pilotage and berthing activities - lighterage, salvage activities - lighthouse activities This class excludes: - cargo handling, see 5224 - operation of marinas, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5223,'Service activities incidental to air transportation', $$This class includes: - activities related to air transport of passengers, animals or freight: - operation of terminal facilities such as airway terminals etc. - airport and air-traffic-control activities - ground service activities on airfields etc. This class also includes: - firefighting and fire-prevention services at airports This class excludes: - cargo handling, see 5224 - operation of flying schools, see 8530, 8549$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5224,'Cargo handling' , $$This class includes: - loading and unloading of goods or passengers' luggage irrespective of the mode of transport used for transportation - stevedoring - loading and unloading of freight railway cars This class excludes: - operation of terminal facilities, see 5221, 5222 and 5223$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5229,'Other transportation support activities', $$This class includes: - forwarding of freight - arranging or organizing of transport operations by rail, road, sea or air - organization of group and individual consignments (including pickup and delivery of goods and grouping of consignments) - logistics activities, i.e. planning, designing and supporting operations of transportation, warehousing and distribution - issue and procurement of transport documents and waybills - activities of customs agents - activities of sea-freight forwarders and air-cargo agents - brokerage for ship and aircraft space - goods-handling operations, e.g. temporary crating for the sole purpose of protecting the goods during transit, uncrating, sampling, weighing of goods This class excludes: - courier activities, see 5320 - provision of motor, marine, aviation and transport insurance, see 6512 - activities of travel agencies, see 7911 - activities of tour operators, see 7912 - tourist assistance activities, see 7990$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5310,'Postal activities', $$This class includes the activities of postal services operating under a universal service obligation. The activities include use of the universal service infrastructure, including retail locations, sorting and processing facilities, and carrier routes to pickup and deliver the mail. The delivery can include letter-post, i.e. letters, postcards, printed papers (newspaper, periodicals, advertising items, etc.), small packets, goods or documents. Also included are other services necessary to support the universal service obligation. This class includes: - pickup, sorting, transport and delivery (domestic or international) of letter-post and (mail-type) parcels and packages by postal services operating under a universal service obligation. One or more modes of transport may be involved and the activity may be carried out with either self-owned (private) transport or via public transport. - collection of letter-mail and parcels from public letter-boxes or from post offices - distribution and delivery of mail and parcels This class excludes: - postal giro, postal savings activities and money order activities, see 6419$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5320,'Courier activities', $$This class includes courier activities not operating under a universal service obligation. This class includes: - pickup, sorting, transport and delivery (domestic or international) of letter-post and (mail-type) parcels and packages by firms not operating under a universal service obligation. One or more modes of transport may be involved and the activity may be carried out with either self-owned (private) transport or via public transport. - distribution and delivery of mail and parcels This class also includes: - home delivery services This class excludes: - transport of freight, see (according to mode of transport) 4912, 4923, 5012, 5022, 5120$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5510,'Short term accommodation activities', $$This class includes the provision of accommodation, typically on a daily or weekly basis, principally for short stay by visitors. This includes the provision of furnished accommodation in guest rooms and suites or complete self-contained units with kitchens, with or without daily or other regular housekeeping services, and may often include a range of additional services such as food and beverage services, parking, laundry services, swimming pools and exercise rooms, recreational facilities and conference and convention facilities. This class includes the provision of short-term accommodation provided by: - hotels - resort hotels - suite / apartment hotels - motels - motor hotels - guesthouses - pensions - bed and breakfast units - visitor flats and bungalows - time-share units - holiday homes - chalets, housekeeping cottages and cabins - youth hostels and mountain refuges This class excludes: - provision of homes and furnished or unfurnished flats or apartments for more permanent use, typically on a monthly or annual basis, see division 68$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5520,'Camping grounds, recreational vehicle parks and trailer parks', $$This class includes: - provision of accommodation in campgrounds, trailer parks, recreational camps and fishing and hunting camps for short stay visitors - provision of space and facilities for recreational vehicles This class also includes accommodation provided by: - protective shelters or plain bivouac facilities for placing tents and/or sleeping bags$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5590,'Other accommodation', $$This class includes the provision of temporary or longer-term accommodation in single or shared rooms or dormitories for students, migrant (seasonal) workers and other individuals. This class includes accommodation provided by: - student residences - school dormitories - workers hostels - rooming and boarding houses - railway sleeping cars$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5610,'Restaurants and mobile food service activities', $$This class includes the provision of food services to customers, whether they are served while seated or serve themselves from a display of items, whether they eat the prepared meals on the premises, take them out or have them delivered. This includes the preparation and serving of meals for immediate consumption from motorized vehicles or non-motorized carts. This class includes activities of: - restaurants - cafeterias - fast-food restaurants - pizza delivery - take-out eating places - ice cream truck vendors - mobile food carts - food preparation in market stalls This class also includes: - restaurant and bar activities connected to transportation, when carried out by separate units This class excludes: - concession operation of eating facilities, see 5629$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5621,'Event catering', $$This class includes the provision of food services based on contractual arrangements with the customer, at the location specified by the customer, for a specific event. This class includes: - event catering This class excludes: - manufacture of perishable food items for resale, see 1079 - retail sale of perishable food items, see division 47$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5629,'Other food service activities', $$This class includes industrial catering, i.e. the provision of food services based on contractual arrangements with the customer, for a specific period of time. Also included is the operation of food concessions at sports and similar facilities. The food is often prepared in a central unit. This class includes: - activities of food service contractors (e.g. for transportation companies) - operation of food concessions at sports and similar facilities - operation of canteens or cafeterias (e.g. for factories, offices, hospitals or schools) on a concession basis This class excludes: - manufacture of perishable food items for resale, see 1079 - retail sale of perishable food items, see division 47$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5630,'Beverage serving activities', $$This class includes the preparation and serving of beverages for immediate consumption on the premises. This class includes activities of: - bars - taverns - cocktail lounges - discotheques (with beverage serving predominant) - beer parlors and pubs - coffee shops - fruit juice bars - mobile beverage vendors This class excludes: - reselling packaged/prepared beverages, see 4711, 4722, 4781, 4799 - operation of discotheques and dance floors without beverage serving, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5811,'Book publishing', $$This class includes the activities of publishing books in print, electronic (CD, electronic displays etc.) or audio form or on the Internet. This class includes: - publishing of books, brochures, leaflets and similar publications, including publishing of dictionaries and encyclopedias - publishing of atlases, maps and charts - publishing of audio books - publishing of encyclopedias etc. on CD-ROM This class excludes: - production of globes, see 3290 - publishing of advertising material, see 5819 - publishing of music and sheet books, see 5920 - activities of independent authors, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5812,'Publishing of directories and mailing lists', $$This class includes the publishing of lists of facts/information (databases) that are protected in their form, but not in their content. These lists can be published in printed or electronic form. This class includes: - publishing of mailing lists - publishing of telephone books - publishing of other directories and compilations, such as case law, pharmaceutical compendia etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5813,'Publishing of newspapers, journals and periodicals', $$This class includes: - publishing of newspapers, including advertising newspapers - publishing of periodicals and other journals, including publishing of radio and television schedules Publishing can be done in print or electronic form, including on the Internet.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5819,'Other publishing activities', $$This class includes: - publishing (including on-line) of: - catalogs - photos, engravings and postcards - greeting cards - forms - posters, reproduction of works of art - advertising material - other printed matter - on-line publishing of statistics or other information This class excludes: - retail sale of software, see 4741 - publishing of advertising newspapers, see 5813 - on-line provision of software (application hosting and application service provisioning), see 6311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5820,'Software publishing', $$This class includes: - publishing of ready-made (non-customized) software: - operating systems - business and other applications - computer games for all platforms This class excludes: - reproduction of software, see 1820 - retail sale of non-customized software, see 4741 - production of software not associated with publishing, see 6201 - on-line provision of software (application hosting and application service provisioning), see 6311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5911,'Motion picture, video and television programme production activities', $$This class includes: - production of motion pictures, videos, television programmes or television commercials This class excludes: - film duplicating (except reproduction of motion picture film for theatrical distribution) as well as reproduction of audio and video tapes, CDs or DVDs from master copies, see 1820 - wholesale of recorded video tapes, CDs, DVDs, see 4649 - retail trade of video tapes, CDs, DVDs, see 4762 - post-production activities, see 5912 - reproduction of motion picture film for theatrical distribution, see 5912 - sound recording and recording of books on tape, see 5920 - creating a complete television channel programme, see 6020 - television broadcasting, see 6020 - film processing other than for the motion picture industry, see 7420 - activities of personal theatrical or artistic agents or agencies, see 7490 - renting of video tapes, DVDs to the general public, see 7722 - real-time (i.e. simultaneous) closed captioning of live television performances, meetings, conferences, etc., see 8299 - activities of own account actors, cartoonists, directors, stage designers and technical specialists, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5912,'Motion picture, video and television programme post-production activities', $$This class includes: - post-production activities such as: - editing, titling, subtitling, credits - closed captioning - computer-produced graphics, animation and special effects - film/tape transfers - activities of motion picture film laboratories and activities of special laboratories for animated films: - developing and processing motion picture film - reproduction of motion picture film for theatrical distribution This class also includes: - activities of stock footage film libraries etc. This class excludes: - film duplicating (except reproduction of motion picture film for theatrical distribution) as well as reproduction of audio and video tapes, CDs or DVDs from master copies, see 1820 - wholesale of recorded video tapes, CDs, DVDs, see 4649 - retail trade of video tapes, CDs, DVDs, see 4762 - film processing other than for the motion picture industry, see 7420 - renting of video tapes, DVDs to the general public, see 7722 - activities of own account actors, cartoonists, directors, stage designers and technical specialists, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5913,'Motion picture, video and television programme distribution activities', $$This class includes: - distributing film, video tapes, DVDs and similar productions to motion picture theatres, television networks and stations and exhibitors This class also includes: - acquiring film, video tape and DVD distribution rights This class excludes: - film duplicating (except reproduction of motion picture film for theatrical distribution) as well as reproduction of audio and video tapes, CDs or DVDs from master copies, see 1820 - reproduction of motion picture film for theatrical distribution, see 5912$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5914,'Motion picture projection activities', $$This class includes: - motion picture or videotape projection in cinemas, in the open air or in other projection facilities - activities of cine-clubs$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	5920,'Sound recording and music publishing activities', $$This class includes: - production of original (sound) master recordings, such as tapes, CDs - sound recording service activities in a studio or elsewhere, including the production of taped (i.e. non-live) radio programming, audio for film, television etc. - music publishing, i.e. activities of: - acquiring and registering copyrights for musical compositions - promoting, authorizing and using these compositions in recordings, radio, television, motion pictures, live performances, print and other media - distributing sound recordings to wholesalers, retailers or directly to the public Units engaged in these activities may own the copyright or act as administrator of the music copyrights on behalf of the copyright owners. This class also includes: - publishing of music and sheet books This class excludes: - reproduction from master copies of music or other sound recordings, see 1820 - wholesale of recorded audio tapes and disks, see 4649$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6010,'Radio broadcasting', $$This class includes: - broadcasting audio signals through radio broadcasting studios and facilities for the transmission of aural programming to the public, to affiliates or to subscribers This class also includes: - activities of radio networks, i.e. assembling and transmitting aural programming to the affiliates or subscribers via over-the-air broadcasts, cable or satellite - radio broadcasting activities over the Internet (Internet radio stations) - data broadcasting integrated with radio broadcasting This class excludes: - production of taped radio programming, see 5920$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6020,'Television programming and broadcasting activities', $$This class includes: - creation of a complete television channel programme, from purchased programme components (e.g. movies, documentaries etc.), self produced programme components (e.g. local news, live reports) or a combination thereof This complete television programme can be either broadcast by the producing unit or produced for transmission by third party distributors, such as cable companies or satellite television providers. The programming may be of a general or specialized nature (e.g. limited formats such as news, sports, education or youth oriented programming), may be made freely available to users or may be available only on a subscription basis. This class also includes: - programming of video-on-demand channels - data broadcasting integrated with television broadcasting This class excludes: - production of television programme elements (e.g. movies, documentaries, commercials), see 5911 - assembly of a package of channels and distribution of that package via cable or satellite to viewers, see division 61$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6110,'Wired telecommunications activities', $$This class includes: - operating, maintaining or providing access to facilities for the transmission of voice, data, text, sound and video using a wired telecommunications infrastructure, including: - operating and maintaining switching and transmission facilities to provide point-to-point communications via landlines, microwave or a combination of landlines and satellite linkups - operating of cable distribution systems (e.g. for distribution of data and television signals) - furnishing telegraph and other non-vocal communications using own facilities The transmission facilities that carry out these activities, may be based on a single technology or a combination of technologies. This class also includes: - purchasing access and network capacity from owners and operators of networks and providing telecommunications services using this capacity to businesses and households - provision of Internet access by the operator of the wired infrastructure This class excludes: - telecommunications resellers, see 6190$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6120,'Wireless telecommunications activities', $$This class includes: - operating, maintaining or providing access to facilities for the transmission of voice, data, text, sound, and video using a wireless telecommunications infrastructure - maintaining and operating paging as well as cellular and other wireless telecommunications networks The transmission facilities provide omni-directional transmission via airwaves and may be based on a single technology or a combination of technologies. This class also includes: - purchasing access and network capacity from owners and operators of networks and providing wireless telecommunications services (except satellite) using this capacity to businesses and households - provision of Internet access by the operator of the wireless infrastructure This class excludes: - telecommunications resellers, see 6190$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6130,'Satellite telecommunications activities', $$This class includes: - operating, maintaining or providing access to facilities for the transmission of voice, data, text, sound and video using a satellite telecommunications infrastructure - delivery of visual, aural or textual programming received from cable networks, local television stations or radio networks to consumers via direct-to-home satellite systems (The units classified here do not generally originate programming material.) This class also includes: - provision of Internet access by the operator of the satellite infrastructure This class excludes: - telecommunications resellers, see 6190$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6190,'Other telecommunications activities', $$This class includes: - provision of specialized telecommunications applications, such as satellite tracking, communications telemetry, and radar station operations - operation of satellite terminal stations and associated facilities operationally connected with one or more terrestrial communications systems and capable of transmitting telecommunications to or receiving telecommunications from satellite systems - provision of Internet access over networks between the client and the ISP not owned or controlled by the ISP, such as dial-up Internet access etc. - provision of telephone and Internet access in facilities open to the public - provision of telecommunications services over existing telecom connections: - VOIP (Voice Over Internet Protocol) provision - telecommunications resellers (i.e. purchasing and reselling network capacity without providing additional services) This class excludes: - provision of Internet access by operators of telecommunications infrastructure, see 6110, 6120, 6130$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6201,'Computer programming activities', $$This class includes the writing, modifying, testing and supporting of software. This class includes: - designing the structure and content of, and/or writing the computer code necessary to create and implement: - systems software (including updates and patches) - software applications (including updates and patches) - databases - web pages - customizing of software, i.e. modifying and configuring an existing application so that it is functional within the clients' information system environment This class excludes: - publishing packaged software, see 5820 - planning and designing computer systems that integrate computer hardware, software and communication technologies, even though providing software might be an integral part, see 6202$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6202,'Computer consultancy and computer facilities management activities', $$This class includes: - planning and designing of computer systems that integrate computer hardware, software and communication technologies The units classified in this class may provide the hardware and software components of the system as part of their integrated services or these components may be provided by third parties or vendors. The units classified in this class often install the system and train and support the users of the system. This class also includes: - provision of on-site management and operation of clients' computer systems and/or data processing facilities, as well as related support services This class excludes: - separate sale of computer hardware or software, see 4651, 4741 - separate installation of mainframe and similar computers, see 3320 - separate installation (setting-up) of personal computers, see 6209 - separate software installation, see 6209$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6209,'Other information technology and computer service activities', $$This class includes other information technology and computer related activities not elsewhere classified, such as: - computer disaster recovery - installation (setting-up) of personal computers - software installation This class excludes: - installation of mainframe and similar computers, see 3320 - computer programming, see 6201 - computer consultancy, see 6202 - computer facilities management, see 6202 - data processing and hosting, see 6311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6311,'Data processing, hosting and related activities', $$This class includes: - provision of infrastructure for hosting, data processing services and related activities - specialized hosting activities such as: - Web hosting - streaming services - application hosting - application service provisioning - general time-share provision of mainframe facilities to clients - data processing activities: - complete processing of data supplied by clients - generation of specialized reports from data supplied by clients - provision of data entry services$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6312,'Web portals', $$This class includes: - operation of web sites that use a search engine to generate and maintain extensive databases of Internet addresses and content in an easily searchable format - operation of other websites that act as portals to the Internet, such as media sites providing periodically updated content$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6391,'News agency activities', $$This class includes: - news syndicate and news agency activities furnishing news, pictures and features to the media This class excludes: - activities of independent photojournalists, see 7420 - activities of independent journalists, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6399,'Other information service activities n.e.c.', $$This class includes other information service activities not elsewhere classified, such as: - telephone based information services - information search services on a contract or fee basis - news clipping services, press clipping services, etc. This class excludes: - activities of call centers, see 8220$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6411,'Central banking', $$This class includes: - issuing and managing the country's currency - monitoring and control of the money supply - taking deposits that are used for clearance between financial institutions - supervising banking operations - holding the country's international reserves - acting as banker to the government The activities of central banks will vary for institutional reasons.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6419,'Other monetary intermediation', $$This class includes the receiving of deposits and/or close substitutes for deposits and extending of credit or lending funds. The granting of credit can take a variety of forms, such as loans, mortgages, credit cards etc. These activities are generally carried out by monetary institutions other than central banks, such as: - banks - savings banks - credit unions This class also includes: - postal giro and postal savings bank activities - credit granting for house purchase by specialized deposit-taking institutions - money order activities This class excludes: - credit granting for house purchase by specialized non-depository institutions, see 6492 - credit card transaction processing and settlement activities, see 6619$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6420,'Activities of holding companies', $$This class includes the activities of holding companies, i.e. units that hold the assets (owning controlling-levels of equity) of a group of subsidiary corporations and whose principal activity is owning the group. The holding companies in this class do not provide any other service to the businesses in which the equity is held, i.e. they do not administer or manage other units. This class excludes: - active management of companies and enterprises, strategic planning and decision making of the company, see 7010$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6430,'Trusts, funds and similar financial entities', $$This class includes legal entities organized to pool securities or other financial assets, without managing, on behalf of shareholders or beneficiaries. The portfolios are customized to achieve specific investment characteristics, such as diversification, risk, rate of return and price volatility. These entities earn interest, dividends and other property income, but have little or no employment and no revenue from the sale of services. This class includes: - open-end investment funds - closed-end investment funds - trusts, estates or agency accounts, administered on behalf of the beneficiaries under the terms of a trust agreement, will or agency agreement - unit investment trust funds This class excludes: - funds and trusts that earn revenue from the sale of goods or services, see ISIC class according to their principal activity - activities of holding companies, see 6420 - pension funding, see 6530 - management of funds, see 6630$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6491,'Financial leasing', $$This class includes: - leasing where the term approximately covers the expected life of the asset and the lessee acquires substantially all the benefits of its use and takes all the risks associated with its ownership. The ownership of the asset may or may not eventually be transferred. Such leases cover all or virtually all costs including interest. This class excludes: - operational leasing, see division 77, according to type of goods leased$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6492,'Other credit granting', $$This class includes: - leasing where the term approximately covers the expected life of the asset and the lessee acquires substantially all the benefits of its use and takes all the risks associated with its ownership. The ownership of the asset may or may not eventually be transferred. Such leases cover all or virtually all costs including interest. This class excludes: - operational leasing, see division 77, according to type of goods leased$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6499,'Other financial service activities, except insurance and pension funding activities, n.e.c.', $$This class includes: - other financial service activities primarily concerned with distributing funds other than by making loans: - factoring activities - writing of swaps, options and other hedging arrangements - activities of viatical settlement companies - own-account investment activities, such as by venture capital companies, investment clubs etc. This class excludes: - financial leasing, see 6491 - security dealing on behalf of others, see 6612 - trade, leasing and renting of real estate property, see division 68 - bill collection without debt buying up, see 8291 - grant-giving activities by membership organizations, see 9499$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6511,'Life insurance', $$This class includes: - underwriting annuities and life insurance policies, disability income insurance policies, and accidental death and dismemberment insurance policies (with or without a substantial savings element).$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6512,'Non-life insurance', $$This class includes: - provision of insurance services other than life insurance: - accident and fire insurance - health insurance - travel insurance - property insurance - motor, marine, aviation and transport insurance - pecuniary loss and liability insurance$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6520,'Reinsurance', $$This class includes: - activities of assuming all or part of the risk associated with existing insurance policies originally underwritten by other insurance carriers$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6530,'Pension funding', $$This class includes legal entities (i.e. funds, plans and/or programmes) organized to provide retirement income benefits exclusively for the sponsor's employees or members. This includes pension plans with defined benefits, as well as individual plans where benefits are simply defined through the member's contribution. This class includes: - employee benefit plans - pension funds and plans - retirement plans This class excludes: - management of pension funds, see 6630 - compulsory social security schemes, see 8430$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6611,'Administration of financial markets', $$This class includes: - operation and supervision of financial markets other than by public authorities, such as: - commodity contracts exchanges - futures commodity contracts exchanges - securities exchanges - stock exchanges - stock or commodity options exchanges$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6612,'Security and commodity contracts brokerage', $$This class includes: - dealing in financial markets on behalf of others (e.g. stock broking) and related activities - securities brokerage - commodity contracts brokerage - activities of bureaux de change etc. This class excludes: - dealing in markets on own account, see 6499 - portfolio management, on a fee or contract basis, see 6630$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6619,'Other activities auxiliary to financial service activities', $$This class includes activities auxiliary to financial service activities not elsewhere classified, such as: - financial transaction processing and settlement activities, including for credit card transactions - investment advisory services - activities of mortgage advisers and brokers This class also includes: - trustee, fiduciary and custody services on a fee or contract basis This class excludes: - activities of insurance agents and brokers, see 6622 - management of funds, see 6630$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6621,'Risk and damage evaluation', $$This class includes the provision of administration services of insurance, such as assessing and settling insurance claims. This class includes: - assessing insurance claims - claims adjusting - risk assessing - risk and damage evaluation - average and loss adjusting - settling insurance claims This class excludes: - appraisal of real estate, see 6820 - appraisal for other purposes, see 7490 - investigation activities, see 8030$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6622,'Activities of insurance agents and brokers', $$This class includes: - activities of insurance agents and brokers (insurance intermediaries) in selling, negotiating or soliciting of annuities and insurance and reinsurance policies$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6629,'Other activities auxiliary to insurance and pension funding', $$This class includes: - activities involved in or closely related to insurance and pension funding (except claims adjusting and activities of insurance agents): - salvage administration - actuarial services This class excludes: - marine salvage activities, see 5222$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6630,'Fund management activities', $$This class includes portfolio and fund management activities on a fee or contract basis, for individuals, businesses and others. This class includes: - management of pension funds - management of mutual funds - management of other investment funds$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6810,'Real estate activities with own or leased property', $$This class includes: - buying, selling, renting and operating of self-owned or leased real estate, such as: - apartment buildings and dwellings - non-residential buildings, including exhibition halls, self-storage facilities, malls and shopping centers - land - provision of homes and furnished or unfurnished flats or apartments for more permanent use, typically on a monthly or annual basis This class also includes: - development of building projects for own operation, i.e. for renting of space in these buildings - subdividing real estate into lots, without land improvement - operation of residential mobile home sites This class excludes: - development of building projects for sale, see 4100 - subdividing and improving of land, see 4290 - operation of hotels, suite hotels and similar accommodation, see 5510 - operation of campgrounds, trailer parks and similar accommodation, see 5520 - operation of workers hostels, rooming houses and similar accommodation, see 5590$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6820,'Real estate activities on a fee or contract basis', $$This class includes the provision of real estate activities on a fee or contract basis including real estate related services. This class includes: - activities of real estate agents and brokers - intermediation in buying, selling and renting of real estate on a fee or contract basis - management of real estate on a fee or contract basis - appraisal services for real estate - activities of real estate escrow agents This class excludes: - legal activities, see 6910 - facilities support services, see 8110 - management of facilities, such as military bases, prisons and other facilities (except computer facilities management), see 8110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6910,'Legal activities', $$This class includes: - legal representation of one party's interest against another party, whether or not before courts or other judicial bodies by, or under supervision of, persons who are members of the bar: - advice and representation in civil cases - advice and representation in criminal cases - advice and representation in connection with labour disputes - general counselling and advising, preparation of legal documents: - articles of incorporation, partnership agreements or similar documents in connection with company formation - patents and copyrights - preparation of deeds, wills, trusts etc. - other activities of notaries public, civil law notaries, bailiffs, arbitrators, examiners and referees This class excludes: - law court activities, see 8423$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	6920,'Accounting, bookkeeping and auditing activities; tax consultancy', $$This class includes: - recording of commercial transactions from businesses or others - preparation or auditing of financial accounts - examination of accounts and certification of their accuracy - preparation of personal and business income tax returns - advisory activities and representation on behalf of clients before tax authorities This class excludes: - data-processing and tabulation activities, see 6311 - management consultancy activities, such as design of accounting systems, cost accounting programmes, budgetary control procedures, see 7020 - bill collection, see 8291$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7010,'Activities of head offices', $$This class includes the overseeing and managing of other units of the company or enterprise; undertaking the strategic or organizational planning and decision making role of the company or enterprise; exercising operational control and manage the day-to-day operations of their related units. This class includes activities of: - head offices - centralized administrative offices - corporate offices - district and regional offices - subsidiary management offices This class excludes: - activities of holding companies, not engaged in managing, see 6420$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7020,'Management consultancy activities', $$This class includes the provision of advice, guidance and operational assistance to businesses and other organizations on management issues, such as strategic and organizational planning; decision areas that are financial in nature; marketing objectives and policies; human resource policies, practices and planning; production scheduling and control planning. This provision of business services may include advice, guidance or operational assistance to businesses and the public service regarding: - public relations and communication - lobbying activities - design of accounting methods or procedures, cost accounting programmes, budgetary control procedures - advice and help to businesses and public services in planning, organization, efficiency and control, management information etc. This class excludes: - design of computer software for accounting systems, see 6201 - legal advice and representation, see 6910 - accounting, bookkeeping and auditing activities, tax consulting, see 6920 - architectural, engineering and other technical advisory activities, see 7110, 7490 - advertising activities, see 7310 - market research and public opinion polling, see 7320 - executive placement or search consulting services, see 7810 - educational consulting activities, see 8550$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7110,'Architectural and engineering activities and related technical consultancy', $$This class includes the provision of architectural services, engineering services, drafting services, building inspection services and surveying and mapping services and the like. This class includes: - architectural consulting activities: - building design and drafting - town and city planning and landscape architecture - engineering design (i.e. applying physical laws and principles of engineering in the design of machines, materials, instruments, structures, processes and systems) and consulting activities for: - machinery, industrial processes and industrial plant - projects involving civil engineering, hydraulic engineering, traffic engineering - water management projects - projects elaboration and realization relative to electrical and electronic engineering, mining engineering, chemical engineering, mechanical, industrial and systems engineering, safety engineering - project management activities related to construction - elaboration of projects using air conditioning, refrigeration, sanitary and pollution control engineering, acoustical engineering etc. - geophysical, geologic and seismic surveying - geodetic surveying activities: - land and boundary surveying activities - hydrologic surveying activities - subsurface surveying activities - cartographic and spatial information activities This class excludes: - test drilling in connection with mining operations, see 0910, 0990 - development or publishing of associated software, see 5820, 6201 - activities of computer consultants, see 6202, 6209 - technical testing, see 7120 - research and development activities related to engineering, see 7210 - industrial design, see 7410 - interior decorating, see 7410 - aerial photography, see 7420$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7120,'Technical testing and analysis', $$This class includes: - performance of physical, chemical and other analytical testing of all types of materials and products (see below for exceptions): - acoustics and vibration testing - testing of composition and purity of minerals etc. - testing activities in the field of food hygiene, including veterinary testing and control in relation to food production - testing of physical characteristics and performance of materials, such as strength, thickness, durability, radioactivity etc. - qualification and reliability testing - performance testing of complete machinery: motors, automobiles, electronic equipment etc. - radiographic testing of welds and joints - failure analysis - testing and measuring of environmental indicators: air and water pollution etc. - certification of products, including consumer goods, motor vehicles, aircraft, pressurized containers, nuclear plants etc. - periodic road-safety testing of motor vehicles - testing with use of models or mock-ups (e.g. of aircraft, ships, dams etc.) - operation of police laboratories This class excludes: - testing of animal specimens, see 7500 - medical laboratory testing, see 8690$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7210,'Research and experimental development on natural sciences and engineering', $$This class includes: - research and experimental development on natural science and engineering: - research and development on natural sciences - research and development on engineering and technology - research and development on medical sciences - research and development on biotechnology - research and development on agricultural sciences - interdisciplinary research and development, predominantly on natural sciences and engineering$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7220,'Research and experimental development on social sciences and humanities', $$This class includes: - research and development on social sciences - research and development on humanities - interdisciplinary research and development, predominantly on social sciences and humanities This class excludes: - market research, see 7320$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7210,'Research and experimental development on natural sciences and engineering', $$This class includes: - research and experimental development on natural science and engineering: - research and development on natural sciences - research and development on engineering and technology - research and development on medical sciences - research and development on biotechnology - research and development on agricultural sciences - interdisciplinary research and development, predominantly on natural sciences and engineering$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7220,'Research and experimental development on social sciences and humanities', $$This class includes: - research and development on social sciences - research and development on humanities - interdisciplinary research and development, predominantly on social sciences and humanities This class excludes: - market research, see 7320$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7310,'Advertising', $$This class includes the provision of a full range of advertising services (i.e. through in-house capabilities or subcontracting), including advice, creative services, production of advertising material, media planning and buying. This class includes: - creation and realization of advertising campaigns: - creating and placing advertising in newspapers, periodicals, radio, television, the Internet and other media - creating and placing of outdoor advertising, e.g. billboards, panels, bulletins and frames, window dressing, showroom design, car and bus carding etc. - media representation, i.e. sale of time and space for various media soliciting advertising - aerial advertising - distribution or delivery of advertising material or samples - provision of advertising space on billboards etc. - creation of stands and other display structures and sites - conducting marketing campaigns and other advertising services aimed at attracting and retaining customers: - promotion of products - point-of-sale marketing - direct mail advertising - marketing consulting This class excludes: - publishing of advertising material, see 5819 - production of commercial messages for radio, television and film, see 5911 - public-relations activities, see 7020 - market research, see 7320 - graphic design activities, see 7410 - advertising photography, see 7420 - convention and trade show organizers, see 8230 - mailing activities, see 8219$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7320,'Market research and public opinion polling', $$This class includes: - investigation into market potential, acceptance and familiarity of products and buying habits of consumers for the purpose of sales promotion and development of new products, including statistical analyses of the results - investigation into collective opinions of the public about political, economic and social issues and statistical analysis thereof$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7410,'Specialized design activities', $$This class includes: - fashion design related to textiles, wearing apparel, shoes, jewelry, furniture and other interior decoration and other fashion goods as well as other personal or household goods - industrial design, i.e. creating and developing designs and specifications that optimize the use, value and appearance of products, including the determination of the materials, construction, mechanism, shape, colour and surface finishes of the product, taking into consideration human characteristics and needs, safety, market appeal and efficiency in production, distribution, use and maintenance - activities of graphic designers - activities of interior decorators This class excludes: - design and programming of web pages, see 6201 - architectural design, see 7110 - engineering design, i.e. applying physical laws and principles of engineering in the design of machines, materials, instruments, structures, processes and systems, see 7110 - theatrical stage-set design, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7420,'Photographic activities', $$This class includes: - commercial and consumer photograph production: - portrait photography for passports, schools, weddings etc. - photography for commercials, publishers, fashion, real estate or tourism purposes - aerial photography - videotaping of events: weddings, meetings etc. - film processing: - developing, printing and enlarging from client-taken negatives or cine-films - film developing and photo printing laboratories - one hour photo shops (not part of camera stores) - mounting of slides - copying and restoring or transparency retouching in connection with photographs - activities of photojournalists This class also includes: - microfilming of documents This class excludes: - processing motion picture film related to the motion picture and television industries, see 5912 - cartographic and spatial information activities, see 7110$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7490,'Other professional, scientific and technical activities n.e.c.', $$This class includes a great variety of service activities generally delivered to commercial clients. It includes those activities for which more advanced professional, scientific and technical skill levels are required, but does not include ongoing, routine business functions that are generally of short duration. This class includes: - translation and interpretation activities - business brokerage activities, i.e. arranging for the purchase and sale of small and medium-sized businesses, including professional practices, but not including real estate brokerage - patent brokerage activities (arranging for the purchase and sale of patents) - appraisal activities other than for real estate and insurance (for antiques, jewellery, etc.) - bill auditing and freight rate information - activities of quantity surveyors - weather forecasting activities - security consulting - agronomy consulting - environmental consulting - other technical consulting - activities of consultants other than architecture, engineering and management consultants This class also includes: - activities carried on by agents and agencies on behalf of individuals usually involving the obtaining of engagements in motion picture, theatrical production or other entertainment or sports attractions and the placement of books, plays, artworks, photographs etc., with publishers, producers etc. This class excludes: - wholesale of used motor vehicles by auctioning, see 4510 - online auction activities (retail), see 4791 - activities of auctioning houses (retail), see 4799 - activities of real estate brokers, see 6820 - bookkeeping activities, see 6920 - activities of management consultants, see 7020 - activities of architecture and engineering consultants, see 7110 - engineering design activities, see 7110 - display of advertisement and other advertising design, see 7310 - creation of stands and other display structures and sites, see 7310 - industrial design activities, see 7410 - activities of convention and trade show organizers, see 8230 - activities of independent auctioneers, see 8299 - administration of loyalty programmes, see 8299 - consumer credit and debt counselling, see 8890 - activities of authors of scientific and technical books, see 9000 - activities of independent journalists, see 9000$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7500,'Veterinary activities', $$This class includes: - animal health care and control activities for farm animals - animal health care and control activities for pet animals These activities are carried out by qualified veterinarians when working in veterinary hospitals as well as when visiting farms, kennels or homes, in own consulting and surgery rooms or elsewhere. This class also includes: - activities of veterinary assistants or other auxiliary veterinary personnel - clinico-pathological and other diagnostic activities pertaining to animals - animal ambulance activities This class excludes: - farm animal boarding activities without health care, see 0162 - sheep shearing, see 0162 - herd testing services, droving services, agistment services, poultry caponizing, see 0162 - activities related to artificial insemination, see 0162 - pet animal boarding activities without health care, see 9609$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7710,'Renting and leasing of motor vehicles', $$This class includes: - renting and operational leasing of the following types of vehicles: - passenger cars (without drivers) - trucks, utility trailers and recreational vehicles This class excludes: - renting or leasing of vehicles or trucks with driver, see 4922, 4923 - financial leasing, see 6491$$
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7721,'Renting and leasing of recreational and sports goods', $$This class includes: - renting of recreational and sports equipment: - pleasure boats, canoes, sailboats, - bicycles - beach chairs and umbrellas - other sports equipment - skis This class excludes: - renting of video tapes and disks, see 7722 - renting of other personal and household goods n.e.c., see 7729 - renting of leisure and pleasure equipment as an integral part of recreational facilities, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7722,'Renting of video tapes and disks', $$This class includes: - renting of video tapes, records, CDs, DVDs etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7729,'Renting and leasing of other personal and household goods', $$This class includes: - renting of all kinds of household or personal goods, to households or industries (except recreational and sports equipment): - textiles, wearing apparel and footwear - furniture, pottery and glass, kitchen and tableware, electrical appliances and house wares - jewellery, musical instruments, scenery and costumes - books, journals and magazines - machinery and equipment used by amateurs or as a hobby e.g. tools for home repairs - flowers and plants - electronic equipment for household use This class excludes: - renting of cars, trucks, trailers and recreational vehicles without driver, see 7710 - renting of recreational and sports goods, see 7721 - renting of video tapes and disks, see 7722 - renting of motorcycles and caravans without driver, see 7730 - renting of office furniture, see 7730 - provision of linen, work uniforms and related items by laundries, see 9601$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7730,'Renting and leasing of other machinery, equipment and tangible goods', $$This class includes: - renting and operational leasing, without operator, of other machinery and equipment that are generally used as capital goods by industries: - engines and turbines - machine tools - mining and oilfield equipment - professional radio, television and communication equipment - motion picture production equipment - measuring and controlling equipment - other scientific, commercial and industrial machinery - renting and operational leasing of land-transport equipment (other than motor vehicles) without drivers: - motorcycles, caravans and campers etc. - railroad vehicles - renting and operational leasing of water-transport equipment without operator: - commercial boats and ships - renting and operational leasing of air transport equipment without operator: - airplanes - hot-air balloons - renting and operational leasing of agricultural and forestry machinery and equipment without operator: - renting of products produced by class 2821, such as agricultural tractors etc. - renting and operational leasing of construction and civil-engineering machinery and equipment without operator: - crane lorries - scaffolds and work platforms, without erection and dismantling - renting and operational leasing of office machinery and equipment without operator: - computers and computer peripheral equipment - duplicating machines, typewriters and word-processing machines - accounting machinery and equipment: cash registers, electronic calculators etc. - office furniture This class also includes: - renting of accommodation or office containers - renting of containers - renting of pallets - renting of animals (e.g. herds, race horses) This class excludes: - renting of agricultural and forestry machinery or equipment with operator, see 0161, 0240 - renting of construction and civil engineering machinery or equipment with operator, see division 43 - renting of water-transport equipment with operator, see division 50 - renting of air-transport equipment with operator, see division 51 - financial leasing, see 6491 - renting of pleasure boats, see 7721 - renting of bicycles, see 7721$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7740,'Leasing of intellectual property and similar products, except copyrighted works', $$This class includes the activities of allowing others to use intellectual property products and similar products for which a royalty payment or licensing fee is paid to the owner of the product (i.e. the asset holder). The leasing of these products can take various forms, such as permission for reproduction, use in subsequent processes or products, operating businesses under a franchise etc. The current owners may or may not have created these products. This class includes: - leasing of intellectual property products (except copyrighted works, such as books or software) - receiving royalties or licensing fees for the use of: - patented entities - trademarks or service marks - brand names - mineral exploration and evaluation - franchise agreements This class excludes: - acquisition of rights and publishing, see divisions 58 and 59 - producing, reproducing and distributing copyrighted works (books, software, film), see divisions 58 and 59 - leasing of real estate, see group 681 - leasing of tangible products (assets), see groups 771, 772, 773 - renting of video tapes and disks, see 7722 - renting of books, see 7729$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7500,'Veterinary activities', $$This class includes: - animal health care and control activities for farm animals - animal health care and control activities for pet animals These activities are carried out by qualified veterinarians when working in veterinary hospitals as well as when visiting farms, kennels or homes, in own consulting and surgery rooms or elsewhere. This class also includes: - activities of veterinary assistants or other auxiliary veterinary personnel - clinico-pathological and other diagnostic activities pertaining to animals - animal ambulance activities This class excludes: - farm animal boarding activities without health care, see 0162 - sheep shearing, see 0162 - herd testing services, droving services, agistment services, poultry caponizing, see 0162 - activities related to artificial insemination, see 0162 - pet animal boarding activities without health care, see 9609$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7710,'Renting and leasing of motor vehicles', $$This class includes: - renting and operational leasing of the following types of vehicles: - passenger cars (without drivers) - trucks, utility trailers and recreational vehicles This class excludes: - renting or leasing of vehicles or trucks with driver, see 4922, 4923 - financial leasing, see 6491$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7721,'Renting and leasing of recreational and sports goods', $$This class includes: - renting of recreational and sports equipment: - pleasure boats, canoes, sailboats, - bicycles - beach chairs and umbrellas - other sports equipment - skis This class excludes: - renting of video tapes and disks, see 7722 - renting of other personal and household goods n.e.c., see 7729 - renting of leisure and pleasure equipment as an integral part of recreational facilities, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7722,'Renting of video tapes and disks', $$This class includes: - renting of video tapes, records, CDs, DVDs etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7729,'Renting and leasing of other personal and household goods', $$This class includes: - renting of all kinds of household or personal goods, to households or industries (except recreational and sports equipment): - textiles, wearing apparel and footwear - furniture, pottery and glass, kitchen and tableware, electrical appliances and house wares - jewellery, musical instruments, scenery and costumes - books, journals and magazines - machinery and equipment used by amateurs or as a hobby e.g. tools for home repairs - flowers and plants - electronic equipment for household use This class excludes: - renting of cars, trucks, trailers and recreational vehicles without driver, see 7710 - renting of recreational and sports goods, see 7721 - renting of video tapes and disks, see 7722 - renting of motorcycles and caravans without driver, see 7730 - renting of office furniture, see 7730 - provision of linen, work uniforms and related items by laundries, see 9601$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7730,'Renting and leasing of other machinery, equipment and tangible goods', $$This class includes: - renting and operational leasing, without operator, of other machinery and equipment that are generally used as capital goods by industries: - engines and turbines - machine tools - mining and oilfield equipment - professional radio, television and communication equipment - motion picture production equipment - measuring and controlling equipment - other scientific, commercial and industrial machinery - renting and operational leasing of land-transport equipment (other than motor vehicles) without drivers: - motorcycles, caravans and campers etc. - railroad vehicles - renting and operational leasing of water-transport equipment without operator: - commercial boats and ships - renting and operational leasing of air transport equipment without operator: - airplanes - hot-air balloons - renting and operational leasing of agricultural and forestry machinery and equipment without operator: - renting of products produced by class 2821, such as agricultural tractors etc. - renting and operational leasing of construction and civil-engineering machinery and equipment without operator: - crane lorries - scaffolds and work platforms, without erection and dismantling - renting and operational leasing of office machinery and equipment without operator: - computers and computer peripheral equipment - duplicating machines, typewriters and word-processing machines - accounting machinery and equipment: cash registers, electronic calculators etc. - office furniture This class also includes: - renting of accommodation or office containers - renting of containers - renting of pallets - renting of animals (e.g. herds, race horses) This class excludes: - renting of agricultural and forestry machinery or equipment with operator, see 0161, 0240 - renting of construction and civil engineering machinery or equipment with operator, see division 43 - renting of water-transport equipment with operator, see division 50 - renting of air-transport equipment with operator, see division 51 - financial leasing, see 6491 - renting of pleasure boats, see 7721 - renting of bicycles, see 7721$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7740,'Leasing of intellectual property and similar products, except copyrighted works', $$This class includes the activities of allowing others to use intellectual property products and similar products for which a royalty payment or licensing fee is paid to the owner of the product (i.e. the asset holder). The leasing of these products can take various forms, such as permission for reproduction, use in subsequent processes or products, operating businesses under a franchise etc. The current owners may or may not have created these products. This class includes: - leasing of intellectual property products (except copyrighted works, such as books or software) - receiving royalties or licensing fees for the use of: - patented entities - trademarks or service marks - brand names - mineral exploration and evaluation - franchise agreements This class excludes: - acquisition of rights and publishing, see divisions 58 and 59 - producing, reproducing and distributing copyrighted works (books, software, film), see divisions 58 and 59 - leasing of real estate, see group 681 - leasing of tangible products (assets), see groups 771, 772, 773 - renting of video tapes and disks, see 7722 - renting of books, see 7729$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7810,'Activities of employment placement agencies', $$This class includes listing employment vacancies and referring or placing applicants for employment, where the individuals referred or placed are not employees of the employment agencies. This class includes: - personnel search, selection referral and placement activities, including executive placement and search activities - activities of casting agencies and bureaus, such as theatrical casting agencies - activities of on-line employment placement agencies This class excludes: - activities of personal theatrical or artistic agents or agencies, see 7490$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7820,'Temporary employment agency activities', $$This class includes: - supplying workers to clients' businesses for limited periods of time to temporarily replace or supplement the working force of the client, where the individuals provided are employees of the temporary help service unit Units classified here do not provide direct supervision of their employees at the clients' work sites.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7830,'Other human resources provision', $$This class includes: - provision of human resources for client businesses This provision of human resources is typically done on a long-term or permanent basis and the units classified here may perform a wide range of human resource and personnel management duties associated with this provision. The units classified here represent the employer of record for the employees on matters relating to payroll, taxes, and other fiscal and human resource issues, but they are not responsible for direction and supervision of employees. This class excludes: - provision of human resources functions together with supervision or running of the business, see the class in the respective economic activity of that business - provision of human resources to temporarily replace or supplement the workforce of the client, see 7820$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7911,'Travel agency activities', $$This class includes: - activities of agencies primarily engaged in selling travel, tour, transportation and accommodation services to the general public and commercial clients$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7912,'Tour operator activities', $$This class includes: - arranging and assembling tours that are sold through travel agencies or directly by tour operators. The tours may include any or all of the following: - transportation - accommodation - food - visits to museums, historical or cultural sites, theatrical, musical or sporting events$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	7990,'Other reservation service and related activities', $$This class includes: - provision of other travel-related reservation services: - reservations for transportation, hotels, restaurants, car rentals, entertainment and sport etc. - provision of time-share exchange services - ticket sales activities for theatrical, sports and other amusement and entertainment events - provision of visitor assistance services: - provision of travel information to visitors - activities of tourist guides - tourism promotion activities This class excludes: - activities of travel agencies and tour operators, see 7911, 7912 - organization and management of events such as meetings, conventions and conferences, see 8230$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8010,'Private security activities', $$This class includes the provision of one or more of the following: guard and patrol services, picking up and delivering money, receipts or other valuable items with personnel and equipment to protect such properties while in transit. This class includes: - armored car services - bodyguard services - polygraph services - fingerprinting services - security guard services This class excludes: - public order and safety activities, see 8423$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8020,'Security systems service activities', $$This class includes: - monitoring or remote monitoring of electronic security alarm systems, such as burglar and fire alarms, including their maintenance - installing, repairing, rebuilding, and adjusting mechanical or electronic locking devices, safes and security vaults The units carrying out these activities may also engage in selling such security systems, mechanical or electronic locking devices, safes and security vaults. This class excludes: - installation of security systems, such as burglar and fire alarms, without later monitoring, see 4321 - selling security systems, mechanical or electronic locking devices, safes and security vaults, without monitoring, installation or maintenance services, see 4759 - security consultants, see 7490 - public order and safety activities, see 8423 - providing key duplication services, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8030,'Investigation activities', $$This class includes: - investigation and detective service activities - activities of all private investigators, independent of the type of client or purpose of investigation$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8110,'Combined facilities support activities', $$This class includes: - provision of a combination of support services within a client's facility, such as general interior cleaning, maintenance, trash disposal, guard and security, mail routing, reception, laundry and related services to support operations within facilities Units classified here provide operating staff to carry out these support activities, but are not involved with or responsible for the core business or activities of the client. This class excludes: - provision of only one of the support services (e.g. general interior cleaning services) or addressing only a single function (e.g. heating), see the appropriate class according to the service provided - provision of management and operating staff for the complete operation of a client's establishment, such as a hotel, restaurant, mine, or hospital, see the class of the unit operated - provision of on site management and operation of a client's computer systems and/or data processing facilities, see 6202 - operation of correctional facilities on a contract or fee basis, see 8423$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8121,'General cleaning of buildings', $$This class includes: - general (non-specialized) cleaning of all types of buildings, such as: - offices - houses or apartments - factories - shops - institutions - general (non-specialized) cleaning of other business and professional premises and multiunit residential buildings These activities cover mostly interior cleaning although they may include the cleaning of associated exterior areas such as windows or passageways. This class excludes: - specialized interior cleaning activities, such as chimney cleaning, cleaning of fireplaces, stoves, furnaces, incinerators, boilers, ventilation ducts, exhaust units, see 8129$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8129,'Other building and industrial cleaning activities', $$This class includes: - exterior cleaning of buildings of all types, including offices, factories, shops, institutions and other business and professional premises and multiunit residential buildings - specialized cleaning activities for buildings such as window cleaning, chimney cleaning and cleaning of fireplaces, stoves, furnaces, incinerators, boilers, ventilation ducts and exhaust units - swimming pool cleaning and maintenance services - cleaning of industrial machinery - bottle cleaning - cleaning of trains, buses, planes, etc. - cleaning of the inside of road and sea tankers - disinfecting and exterminating activities - street sweeping and snow and ice removal - other building and industrial cleaning activities, n.e.c. This class excludes: - agriculture pest control, see 0161 - cleaning of sewers and drains, see 3700 - automobile cleaning, car wash, see 4520$$ 
);


INSERT INTO "isic_class" (code,name,description) VALUES (
	8130,'Landscape care and maintenance service activities', $$This class includes: - planting, care and maintenance of: - parks and gardens for: - private and public housing - public and semi-public buildings (schools, hospitals, administrative buildings, church buildings etc.) - municipal grounds (parks, green areas, cemeteries etc.) - highway greenery (roads, train lines and tramlines, waterways, ports) - industrial and commercial buildings - greenery for: - buildings (roof gardens, façade greenery, indoor gardens) - sports grounds (e.g. football fields, golf courses etc.), play grounds, lawns for sunbathing and other recreational parks - stationary and flowing water (basins, alternating wet areas, ponds, swimming pools, ditches, watercourses, plant sewage systems) - plants for protection against noise, wind, erosion, visibility and dazzling This class also includes: - maintenance of land in order to keep it in good ecological condition This class excludes: - commercial production and planting for commercial production of plants, trees, see divisions 01 and 02 - tree nurseries (except forest tree nurseries), see 0130 - maintenance of land to keep it in good condition for agricultural use, see 0161 - construction activities for landscaping purposes, see section F - landscape design and architecture activities, see 7110 - operation of botanical gardens, see 9103$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8211,'Combined office administrative service activities', $$This class includes: - provision of a combination of day-to-day office administrative services, such as reception, financial planning, billing and record keeping, personnel and physical distribution (mail services) and logistics for others on a contract or fee basis. This class excludes: - provision of operating staff to carry out the complete operations of a business, see class according to the business/activity performed - provision of only one particular aspect of these activities, see class according to that particular activity$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8219,'Photocopying, document preparation and other specialized office support activities', $$This class includes a variety of copying, document preparation and specialized office support activities. The document copying/printing activities included here cover only short-run type printing activities. This class includes: - document preparation - document editing or proofreading - typing, word processing, or desktop publishing - secretarial support services - transcription of documents, and other secretarial services - letter or resume writing - provision of mailbox rental and other mailing activities (except direct mail advertising) - photocopying - duplicating - blueprinting - other document copying services without also providing printing services, such as offset printing, quick printing, digital printing, prepress services This class excludes: - printing of documents (offset printing, quick printing etc.), see 1811 - direct mail advertising, see 7310 - specialized stenotype services such as court reporting, see 8299 - public stenography services, see 8299$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8220,'Activities of call centres', $$This class includes: - activities of inbound call centres, answering calls from clients by using human operators, automatic call distribution, computer telephone integration, interactive voice response systems or similar methods to receive orders, provide product information, deal with customer requests for assistance or address customer complaints - activities of outbound call centers using similar methods to sell or market goods or services to potential customers, undertake market research or public opinion polling and similar activities for clients$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8230,'Organization of conventions and trade shows', $$This class includes: - organization, promotion and/or management of events, such as business and trade shows, conventions, conferences and meetings, whether or not including the management and provision of the staff to operate the facilities in which these events take place$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8291,'Activities of collection agencies and credit bureaus', $$This class includes: - collection of payments for claims and remittance of payments collected to the clients, such as bill or debt collection services - compiling of information, such as credit and employment histories on individuals and credit histories on businesses and providing the information to financial institutions, retailers and others who have a need to evaluate the creditworthiness of these persons and businesses$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8292,'Packaging activities', $$This class includes: - packaging activities on a fee or contract basis, whether or not these involve an automated process: - bottling of liquids, including beverages and food - packaging of solids (blister packaging, foil-covered etc.) - security packaging of pharmaceutical preparations - labeling, stamping and imprinting - parcel-packing and gift-wrapping This class excludes: - manufacture of soft drinks and production of mineral water, see 1104 - packaging activities incidental to transport, see 5229$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8299,'Other business support service activities n.e.c.', $$This class includes: - providing verbatim reporting and stenotype recording of live legal proceedings and transcribing subsequent recorded materials, such as: - court reporting or stenotype recording services - public stenography services - real-time (i.e. simultaneous) closed captioning of live television performances of meetings, conferences - address bar coding services - bar code imprinting services - fundraising organization services on a contract or fee basis - mail presorting services - repossession services - parking meter coin collection services - activities of independent auctioneers - administration of loyalty programmes - other support activities typically provided to businesses not elsewhere classified This class excludes: - provision of document transcription services, see 8219 - providing film or tape captioning or subtitling services, see 5912$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8411,'General public administration activities', $$This class includes: - executive and legislative administration of central, regional and local bodies - administration and supervision of fiscal affairs: - operation of taxation schemes - duty/tax collection on goods and tax violation investigation - customs administration - budget implementation and management of public funds and public debt: - raising and receiving of moneys and control of their disbursement - administration of overall (civil) R&D policy and associated funds - administration and operation of overall economic and social planning and statistical services at the various levels of government This class excludes: - operation of government owned or occupied buildings, see 6810, 6820 - administration of R&D policies intended to increase personal well-being and of associated funds, see 8412 - administration of R&D policies intended to improve economic performance and competitiveness, see 8413 - administration of defence-related R&D policies and of associated funds, see 8422 - operation of government archives, see 9101$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8412,'Regulation of the activities of providing health care, education, cultural services and other social services, excluding social security', $$This class includes: - public administration of programmes aimed to increase personal well-being: - health - education - culture - sport - recreation - environment - housing - social services - public administration of R&D policies and associated funds for these areas This class also includes: - sponsoring of recreational and cultural activities - distribution of public grants to artists - administration of potable water supply programmes - administration of waste collection and disposal operations - administration of environmental protection programmes - administration of housing programmes This class excludes: - sewage, refuse disposal and remediation activities, see divisions 37, 38, 39 - compulsory social security activities, see 8430 - education activities, see division 85 - human health-related activities, see division 86 - activities of libraries and archives (private, public or government operated), see 9101 - operation of museums and other cultural institutions, see 9102 - sporting or other recreational activities, see division 93$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8413,'Regulation of and contribution to more efficient operation of businesses', $$This class includes: - public administration and regulation, including subsidy allocation, for different economic sectors: - agriculture - land use - energy and mining resources - infrastructure - transport - communication - hotels and tourism - wholesale and retail trade - administration of R&D policies and associated funds to improve economic performance - administration of general labour affairs - implementation of regional development policy measures, e.g. to reduce unemployment This class excludes: - research and experimental development activities, see division 72$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8421,'Foreign affairs', $$This class includes: - administration and operation of the ministry of foreign affairs and diplomatic and consular missions stationed abroad or at offices of international organizations - administration, operation and support for information and cultural services intended for distribution beyond national boundaries - aid to foreign countries, whether or not routed through international organizations - provision of military aid to foreign countries - management of foreign trade, international financial and foreign technical affairs This class excludes: - international disaster or conflict refugee services, see 8890$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8422,'Defence activities', $$This class includes: - administration, supervision and operation of military defence affairs and land, sea, air and space defence forces such as: - combat forces of army, navy and air force - engineering, transport, communications, intelligence, material, personnel and other non-combat forces and commands - reserve and auxiliary forces of the defence establishment - military logistics (provision of equipment, structures, supplies etc.) - health activities for military personnel in the field - administration, operation and support of civil defence forces - support for the working out of contingency plans and the carrying out of exercises in which civilian institutions and populations are involved - administration of defence-related R&D policies and related funds This class excludes: - research and experimental development activities, see division 72 - provision of military aid to foreign countries, see 8421 - activities of military tribunals, see 8423 - provision of supplies for domestic emergency use in case of peacetime disasters, see 8423 - educational activities of military schools, colleges and academies, see 8530 - activities of military hospitals, see 8610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8423,'Public order and safety activities', $$This class includes: - administration and operation of regular and auxiliary police forces supported by public authorities and of port, border, coastguards and other special police forces, including traffic regulation, alien registration, maintenance of arrest records - firefighting and fire prevention: - administration and operation of regular and auxiliary fire brigades in fire prevention, firefighting, rescue of persons and animals, assistance in civic disasters, floods, road accidents etc. - administration and operation of administrative civil and criminal law courts, military tribunals and the judicial system, including legal representation and advice on behalf of the government or when provided by the government in cash or services - rendering of judgements and interpretations of the law - arbitration of civil actions - prison administration and provision of correctional services, including rehabilitation services, regardless of whether their administration and operation is done by government units or by private units on a contract or fee basis - provision of supplies for domestic emergency use in case of peacetime disasters This class excludes: - forestry fire-protection and fire-fighting services, see 0240 - oil and gas field fire fighting, see 0910 - firefighting and fire-prevention services at airports provided by non-specialized units, see 5223 - advice and representation in civil, criminal and other cases, see 6910 - operation of police laboratories, see 7120 - administration and operation of military armed forces, see 8422 - activities of prison schools, see division 85 - activities of prison hospitals, see 8610$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8430,'Compulsory social security activities', $$This class includes: - funding and administration of government-provided social security programmes: - sickness, work-accident and unemployment insurance - retirement pensions - programmes covering losses of income due to maternity, temporary disablement, widowhood etc. This class excludes: - non-compulsory social security, see 6530 - provision of welfare services and social work (without accommodation), see 8810, 8890$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8510,'Pre-primary and primary education', $$This class includes provision of the type of education that lays the foundation for lifelong learning and human development and is capable of furthering education opportunities. Such units provide programmes that are usually on a more subject-oriented pattern using more specialized teachers, and more often employ several teachers conducting classes in their field of specialization. Education can be provided in classrooms or through radio, television broadcast, Internet, correspondence or at home. Subject specialization at this level often begins to have some influence even on the educational experience of those pursuing a general programme. Such programmes are designated to qualify students either for technical and vocational education or for entrance to higher education without any special subject prerequisite. This class includes: - general school education in the first stage of the secondary level corresponding more or less to the period of compulsory school attendance - general school education in the second stage of the secondary level giving, in principle, access to higher education This class also includes: - special education for handicapped students at this level This class excludes: - adult education as defined in group 854$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8521,'General secondary education', $$This class includes provision of the type of education that lays the foundation for lifelong learning and human development and is capable of furthering education opportunities. Such units provide programmes that are usually on a more subject-oriented pattern using more specialized teachers, and more often employ several teachers conducting classes in their field of specialization. Education can be provided in classrooms or through radio, television broadcast, Internet, correspondence or at home. Subject specialization at this level often begins to have some influence even on the educational experience of those pursuing a general programme. Such programmes are designated to qualify students either for technical and vocational education or for entrance to higher education without any special subject prerequisite. This class includes: - general school education in the first stage of the secondary level corresponding more or less to the period of compulsory school attendance - general school education in the second stage of the secondary level giving, in principle, access to higher education This class also includes: - special education for handicapped students at this level This class excludes: - adult education as defined in group 854$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8522,'Technical and vocational secondary education', $$This class includes education typically emphasizing subject-matter specialization and instruction in both theoretical background and practical skills generally associated with present or prospective employment. The aim of a programme can vary from preparation for a general field of employment to a very specific job. Instruction may be provided in diverse settings, such as the unit's or client's training facilities, educational institutions, the workplace, or the home, and through correspondence, television, Internet, or other means. This class includes: - technical and vocational education below the level of higher education as defined in 853 This class also includes: - instruction for tourist guides - instruction for chefs, hoteliers and restaurateurs - special education for handicapped students at this level - cosmetology and barber schools - computer repair training - driving schools for occupational drivers e.g. of trucks, buses, coaches This class excludes: - technical and vocational education at post-secondary and university levels, see 8530 - adult education as defined in group 854 - performing art instruction for recreation, hobby and self-development purposes, see 8542 - automobile driving schools not intended for occupational drivers, see 8549 - job training forming part of social work activities without accommodation, see 8810, 8890$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8530,'Higher education', $$This class includes the provision of post-secondary non-tertiary and tertiary education, including granting of degrees at baccalaureate, graduate or post-graduate level. The requirement for admission is at least a high school diploma or equivalent general academic training. Education can be provided in classrooms or through radio, television broadcast, Internet or correspondence. This class includes: - post-secondary non-tertiary education - first stage of tertiary education (not leading to an advanced research qualification) - second stage of tertiary education (leading to an advanced research qualification) This class also includes: - performing arts schools providing higher education This class excludes: - adult education as defined in group 854$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8541,'Sports and recreation education', $$This class includes the provision of instruction in athletic activities to groups or individuals, such as by camps and schools. Overnight and day sports instruction camps are also included. This class does not include activities of academic schools, colleges and universities. Instruction may be provided in diverse settings, such as the unit's or client's training facilities, educational institutions or by other means. Instruction provided in this class is formally organized. This class includes: - sports instruction (baseball, basketball, cricket, football, etc) - camps, sports instruction - cheerleading instruction - gymnastics instruction - riding instruction, academies or schools - swimming instruction - professional sports instructors, teachers, coaches - martial arts instruction - card game instruction (such as bridge) - yoga instruction This class excludes: - cultural education, see 8542$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8542,'Cultural education', $$This class includes provision of instruction in the arts, drama and music. Units giving this type of instructions might be named "schools", "studios", "classes" etc. They provide formally organized instruction, mainly for hobby, recreational or self-development purposes, but such instruction does not lead to a professional diploma, baccalaureate or graduate degree. This class includes: - piano teachers and other music instruction - art instruction - dance instruction and dance studios - drama schools (except academic) - fine arts schools (except academic) - performing arts schools (except academic) - photography schools (except commercial)$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8549,'Other education n.e.c.', $$This class includes the provision of instruction and specialized training, generally for adults, not comparable to the general education in groups 851-853. This class does not include activities of academic schools, colleges, and universities. Instruction may be provided in diverse settings, such as the unit's or client's training facilities, educational institutions, the workplace, or the home, and through correspondence, radio, television, Internet, in classrooms or by other means. Such instruction does not lead to a high school diploma, baccalaureate or graduate degree. This class includes: - education that is not definable by level - academic tutoring services - college board preparation - learning centres offering remedial courses - professional examination review courses - language instruction and conversational skills instruction - speed reading instruction - religious instruction This class also includes: - automobile driving schools - flying schools - lifeguard training - survival training - public speaking training - computer training This class excludes: - adult literacy programmes see 8510 - general secondary education, see 8521 - driving schools for occupational drivers, see 8522 - higher education, see 8530 - cultural education, see 8542$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8550,'Educational support activities', $$This class includes: - provision of non-instructional services that support educational processes or systems: - educational consulting - educational guidance counseling services - educational testing evaluation services - educational testing services - organization of student exchange programs This class excludes: - research and experimental development on social sciences and humanities, see 7220$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8610,'Hospital activities', $$This class includes: - short- or long-term hospital activities, i.e. medical, diagnostic and treatment activities, of general hospitals (e.g. community and regional hospitals, hospitals of non-profit organizations, university hospitals, military-base and prison hospitals) and specialized hospitals (e.g. mental health and substance abuse hospitals, hospitals for infectious diseases, maternity hospitals, specialized sanatoriums) The activities are chiefly directed to inpatients, are carried out under the direct supervision of medical doctors and include: - services of medical and paramedical staff - services of laboratory and technical facilities, including radiologic and anaesthesiologic services - emergency room services - provision of operating room services, pharmacy services, food and other hospital services - services of family planning centres providing medical treatment such as sterilization and termination of pregnancy, with accommodation This class excludes: - laboratory testing and inspection of all types of materials and products, except medical, see 7120 - veterinary activities, see 7500 - health activities for military personnel in the field, see 8422 - dental practice activities of a general or specialized nature, e.g. dentistry, endodontic and pediatric dentistry; oral pathology, orthodontic activities, see 8620 - private consultants' services to inpatients, see 8620 - medical laboratory testing, see 8690 - ambulance transport activities, see 8690$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8620,'Medical and dental practice activities', $$This class includes: - medical consultation and treatment in the field of general and specialized medicine by general practitioners and medical specialists and surgeons - dental practice activities of a general or specialized nature, e.g. dentistry, endodontic and pediatric dentistry; oral pathology - orthodontic activities - family planning centres providing medical treatment, such as sterilization and termination of pregnancy, without accommodation These activities can be carried out in private practice, group practices and in hospital outpatient clinics, and in clinics such as those attached to firms, schools, homes for the aged, labour organizations and fraternal organizations, as well as in patients' homes. This class also includes: - dental activities in operating rooms - private consultants' services to inpatients This class excludes: - production of artificial teeth, denture and prosthetic appliances by dental laboratories, see 3250 - inpatient hospital activities, see 8610 - paramedical activities such as those of midwives, nurses and physiotherapists, see 8690$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8690,'Other human health activities', $$This class includes: - activities for human health not performed by hospitals or by medical doctors or dentists: - activities of nurses, midwives, physiotherapists or other paramedical practitioners in the field of optometry, hydrotherapy, medical massage, occupational therapy, speech therapy, chiropody, homeopathy, chiropractice, acupuncture etc. These activities may be carried out in health clinics such as those attached to firms, schools, homes for the aged, labour organizations and fraternal organizations and in residential health facilities other than hospitals, as well as in own consulting rooms, patients' homes or elsewhere. These activities do not involve medical treatment. This class also includes: - activities of dental paramedical personnel such as dental therapists, school dental nurses and dental hygienists, who may work remote from, but are periodically supervised by, the dentist - activities of medical laboratories such as: - X-ray laboratories and other diagnostic imaging centres - blood analysis laboratories - activities of blood banks, sperm banks, transplant organ banks etc. - ambulance transport of patients by any mode of transport including airplanes. These services are often provided during a medical emergency. This class excludes: - production of artificial teeth, denture and prosthetic appliances by dental laboratories, see 3250 - transfer of patients, with neither equipment for lifesaving nor medical personnel, see divisions 49, 50, 51 - non-medical laboratory testing, see 7120 - testing activities in the field of food hygiene, see 7120 - hospital activities, see 8610 - medical and dental practice activities, see 8620 - nursing care facilities, see 8710$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8710,'Residential nursing care facilities', $$This class includes: - activities of: - homes for the elderly with nursing care - convalescent homes - rest homes with nursing care - nursing care facilities - nursing homes This class excludes: - in-home services provided by health care professionals, see division 86 - activities of homes for the elderly without or with minimal nursing care, see 8730 - social work activities with accommodation, such as orphanages, children's boarding homes and hostels, temporary homeless shelters, see 8790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8720,'Residential care activities for mental retardation, mental health and substance abuse', $$This class includes the provision of residential care (but not licensed hospital care) to people with mental retardation, mental illness, or substance abuse problems. Facilities provide room, board, protective supervision and counselling and some health care. It also includes provision of residential care and treatment for patients with mental health and substance abuse illnesses. This class includes: - activities of: - facilities for treatment of alcoholism and drug addiction - psychiatric convalescent homes - residential group homes for the emotionally disturbed - mental retardation facilities - mental health halfway houses This class excludes: - social work activities with accommodation, such as temporary homeless shelters, see 8790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8730,'Residential care activities for the elderly and disabled', $$This class includes the provision of residential and personal care services for the elderly and disabled who are unable to fully care for themselves and/or who do not desire to live independently. The care typically includes room, board, supervision, and assistance in daily living, such as housekeeping services. In some instances these units provide skilled nursing care for residents in separate on-site facilities. This class includes: - activities of: - assisted-living facilities - continuing care retirement communities - homes for the elderly with minimal nursing care - rest homes without nursing care This class excludes: - activities of homes for the elderly with nursing care, see 8710 - social work activities with accommodation where medical treatment or accommodation are not important elements, see 8790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8790,'Other residential care activities', $$This class includes the provision of residential and personal care services for persons, except the elderly and disabled, who are unable to fully care for themselves or who do not desire to live independently. This class includes: - activities provided on a round-the-clock basis directed to provide social assistance to children and special categories of persons with some limits on ability for self-care, but where medical treatment or education are not important elements: - orphanages - children's boarding homes and hostels - temporary homeless shelters - institutions that take care of unmarried mothers and their children The activities may be carried out by public or private organizations. This class also includes: - activities of: - halfway group homes for persons with social or personal problems - halfway homes for delinquents and offenders - disciplinary camps This class excludes: - funding and administration of compulsory social security programmes, see 8430 - activities of nursing care facilities, see 8710 - residential care activities for mental retardation, mental health and substance abuse, see 8720 - residential care activities for the elderly or disabled, see 8730 - adoption activities, see 8890 - short-term shelter activities for disaster victims, see 8890$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8810,'Social work activities without accommodation for the elderly and disabled', $$This class includes: - social, counselling, welfare, referral and similar services which are aimed at the elderly and disabled in their homes or elsewhere and carried out by public or by private organizations, national or local self-help organizations and by specialists providing counselling services: - visiting of the elderly and disabled - day-care activities for the elderly or for handicapped adults - vocational rehabilitation and habilitation activities for disabled persons provided that the education component is limited This class excludes: - funding and administration of compulsory social security programmes, see 8430 - activities similar to those described in this class, but including accommodation, see 8730 - day-care activities for handicapped children, see 8890$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	8890,'Other social work activities without accommodation', $$This class includes: - social, counselling, welfare, refugee, referral and similar services which are delivered to individuals and families in their homes or elsewhere and carried out by public or by private organizations, disaster relief organizations and national or local self-help organizations and by specialists providing counselling services: - welfare and guidance activities for children and adolescents - adoption activities, activities for the prevention of cruelty to children and others - household budget counselling, marriage and family guidance, credit and debt counselling services - community and neighbourhood activities - activities for disaster victims, refugees, immigrants etc., including temporary or extended shelter for them - vocational rehabilitation and habilitation activities for unemployed persons provided that the education component is limited - eligibility determination in connection with welfare aid, rent supplements or food stamps - child day-care activities, including for handicapped children - day facilities for the homeless and other socially weak groups - charitable activities like fund-raising or other supporting activities aimed at social work This class excludes: - funding and administration of compulsory social security programmes, see 8430 - activities similar to those described in this class, but including accommodation, see 8790$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9000,'Creative, arts and entertainment activities', $$This class includes the operation of facilities and provision of services to meet the cultural and entertainment interests of their customers. This includes the production and promotion of, and participation in, live performances, events or exhibits intended for public viewing; the provision of artistic, creative or technical skills for the production of artistic products and live performances. This class includes: - production of live theatrical presentations, concerts and opera or dance productions and other stage productions: - activities of groups, circuses or companies, orchestras or bands - activities of individual artists such as authors, actors, directors, musicians, lecturers or speakers, stage-set designers and builders etc. - operation of concert and theatre halls and other arts facilities - activities of sculptors, painters, cartoonists, engravers, etchers etc. - activities of individual writers, for all subjects including fictional writing, technical writing etc. - activities of independent journalists - restoring of works of art such as paintings etc. This class also includes: - activities of producers or entrepreneurs of arts live events, with or without facilities This class excludes: - restoring of stained glass windows, see 2310 - manufacture of statues, other than artistic originals, see 2396 - restoring of organs and other historical musical instruments, see 3319 - restoring of historical sites and buildings, see 4100 - motion picture and video production, see 5911, 5912 - operation of cinemas, see 5914 - activities of personal theatrical or artistic agents or agencies, see 7490 - casting activities, see 7810 - activities of ticket agencies, see 7990 - operation of museums of all kinds, see 9102 - sports and amusement and recreation activities, see division 93 - restoring of furniture (except museum type restoration), see 9524$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9101,'Library and archives activities', $$This class includes: - documentation and information activities of libraries of all kinds, reading, listening and viewing rooms, public archives providing service to the general public or to a special clientele, such as students, scientists, staff, members as well as operation of government archives: - organization of a collection, whether specialized or not - cataloguing collections - lending and storage of books, maps, periodicals, films, records, tapes, works of art etc. - retrieval activities in order to comply with information requests etc. - stock photo libraries and services$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9102,'Museums activities and operation of historical sites and buildings', $$This class includes: - operation of museums of all kinds: - art museums, museums of jewellery, furniture, costumes, ceramics, silverware - natural history, science and technological museums, historical museums, including military museums - other specialized museums - open-air museums - operation of historical sites and buildings This class excludes: - renovation and restoration of historical sites and buildings, see section F - restoration of works of art and museum collection objects, see 9000 - activities of libraries and archives, see 9101$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9103,'Botanical and zoological gardens and nature reserves activities', $$This class includes: - operation of botanical and zoological gardens, including children's zoos - operation of nature reserves, including wildlife preservation, etc. This class excludes: - landscape and gardening services, see 8130 - operation of sport fishing and hunting preserves, see 9319$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9200,'Gambling and betting activities', $$This class includes: - bookmaking and other betting operations - off-track betting - operation of casinos, including "floating casinos" - sale of lottery tickets - operation (exploitation) of coin-operated gambling machines - operation of virtual gambling web sites This class excludes: - operation (exploitation) of coin-operated games, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9311,'Operation of sports facilities', $$This class includes: - operation of facilities for indoor or outdoor sports events (open, closed or covered, with or without spectator seating): - football, hockey, cricket, baseball, jai-alai stadiums - racetracks for auto, dog, horse races - swimming pools and stadiums - track and field stadiums - winter sports arenas and stadiums - ice-hockey arenas - boxing arenas - golf courses - bowling lanes - fitness centers - organization and operation of outdoor or indoor sports events for professionals or amateurs by organizations with own facilities This class includes managing and providing the staff to operate these facilities. This class excludes: - renting of recreation and sports equipment, see 7721 - operation of ski hills, see 9329 - park and beach activities, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9312,'Activities of sports clubs', $$This class includes the activities of sports clubs, which, whether professional, semi-professional or amateur clubs, give their members the opportunity to engage in sporting activities. This class includes: - operation of sports clubs: - football clubs - bowling clubs - swimming clubs - golf clubs - boxing clubs - body-building clubs - winter sports clubs - chess clubs - track and field clubs - shooting clubs, etc. This class excludes: - sports instruction by individual teachers, trainers, see 8541 - operation of sports facilities, see 9311 - organization and operation of outdoor or indoor sports events for professionals or amateurs by sports clubs with their own facilities, see 9311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9319,'Other sports activities', $$This class includes: - activities of producers or promoters of sports events, with or without facilities - activities of individual own-account sportsmen and athletes, referees, judges, timekeepers etc. - activities of sports leagues and regulating bodies - activities related to promotion of sporting events - activities of racing stables, kennels and garages - operation of sport fishing and hunting preserves - activities of mountain guides - support activities for sport or recreational hunting and fishing This class excludes: - breeding of racing horses, see 0142 - renting of sports equipment, see 7721 - activities of sport and game schools, see 8541 - activities of sports instructors, teachers, coaches, see 8541 - organization and operation of outdoor or indoor sports events for professionals or amateurs by sports clubs with/without own facilities, see 9311, 9312 - park and beach activities, see 9329$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9321,'Activities of amusement parks and theme parks', $$This class includes: - activities of amusement parks or theme parks, including the operation of a variety of attractions, such as mechanical rides, water rides, games, shows, theme exhibits and picnic grounds$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9329,'Other amusement and recreation activities n.e.c.', $$This class includes: - activities of recreation parks, beaches, including renting of facilities such as bathhouses, lockers, chairs etc. - operation of recreational transport facilities, e.g. marinas - operation of ski hills - renting of leisure and pleasure equipment as an integral part of recreational facilities - operation of fairs and shows of a recreational nature - operation of discotheques and dance floors - operation (exploitation) of coin-operated games - other amusement and recreation activities (except amusement parks and theme parks) not elsewhere classified This class also includes: - activities of producers or entrepreneurs of live events other than arts or sports events, with or without facilities This class excludes: - fishing cruises, see 5011, 5021 - provision of space and facilities for short stay by visitors in recreational parks and forests and campgrounds, see 5520 - beverage serving activities of discotheques, see 5630 - trailer parks, campgrounds, recreational camps, hunting and fishing camps, campsites and campgrounds, see 5520 - separate renting of leisure and pleasure equipment, see 7721 - operation (exploitation) of coin-operated gambling machines, see 9200 - activities of amusement parks and theme parks, see 9321$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9411, 'Activities of business and employers membership organizations', $$This class includes: - activities of organizations whose members' interests centre on the development and prosperity of enterprises in a particular line of business or trade, including farming, or on the economic growth and climate of a particular geographical area or political subdivision without regard for the line of business. - activities of federations of such associations - activities of chambers of commerce, guilds and similar organizations - dissemination of information, representation before government agencies, public relations and labour negotiations of business and employer organizations This class excludes: - activities of trade unions, see 9420$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9412,'Activities of professional membership organizations', $$This class includes: - activities of organizations whose members' interests centre chiefly on a particular scientific discipline, professional practice or technical field, such as medical associations, legal associations, accounting associations, engineering associations, architects associations etc. - activities of associations of specialists engaged in cultural activities, such as associations of writers, painters, performers of various kinds, journalists etc. - dissemination of information, the establishment and supervision of standards of practice, representation before government agencies and public relations of professional organizations This class also includes: - activities of learned societies This class excludes: - education provided by these organizations, see division 85$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9420,'Activities of trade unions', $$This class includes: - promoting of the interests of organized labor and union employees This class also includes: - activities of associations whose members are employees interested chiefly in the representation of their views concerning the salary and work situation, and in concerted action through organization - activities of single plant unions, of unions composed of affiliated branches and of labour organizations composed of affiliated unions on the basis of trade, region, organizational structure or other criteria This class excludes: - education provided by such organizations, see division 85$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9491,'Activities of religious organizations', $$This class includes: - activities of religious organizations or individuals providing services directly to worshippers in churches, mosques, temples, synagogues or other places - activities of organizations providing monastery and convent services - religious retreat activities This class also includes: - religious funeral service activities This class excludes: - education provided by such organizations, see division 85 - health activities by such organizations, see division 86 - social work activities by such organizations, see divisions 87 and 88$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9492,'Activities of political organizations', $$This class includes: - activities of political organizations and auxiliary organizations such as young people's auxiliaries associated with a political party. These organizations chiefly engage in influencing decision-taking in public governing bodies by placing members of the party or those sympathetic to the party in political office and involve the dissemination of information, public relations, fund-raising etc.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9499,'Activities of other membership organizations n.e.c.', $$This class includes: - activities of organizations not directly affiliated to a political party furthering a public cause or issue by means of public education, political influence, fund-raising etc.: - citizens initiative or protest movements - environmental and ecological movements - organizations supporting community and educational facilities n.e.c. - organizations for the protection and betterment of special groups, e.g. ethnic and minority groups - associations for patriotic purposes, including war veterans' associations - consumer associations - automobile associations - associations for the purpose of social acquaintanceship such as rotary clubs, lodges etc. - associations of youth, young persons' associations, student associations, clubs and fraternities etc. - associations for the pursuit of a cultural or recreational activity or hobby (other than sports or games), e.g. poetry, literature and book clubs, historical clubs, gardening clubs, film and photo clubs, music and art clubs, craft and collectors' clubs, social clubs, carnival clubs etc. This class also includes: - grant giving activities by membership organizations or others This class excludes: - activities of professional artistic groups or organizations, see 9000 - activities of sports clubs, see 9312 - activities of professional membership associations, see 9412$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9511,'Repair of computers and peripheral equipment', $$This class includes the repair of electronic equipment, such as computers and computing machinery and peripheral equipment. This class includes: - repair and maintenance of: - desktop computers - laptop computers - magnetic disk drives, flash drives and other storage devices - optical disk drives (CD-RW, CD-ROM, DVD-ROM, DVD-RW) - printers - monitors - keyboards - mice, joysticks and trackball accessories - internal and external computer modems - dedicated computer terminals - computer servers - scanners, including bar code scanners - smart card readers - virtual reality helmets - computer projectors This class also includes: - repair and maintenance of: - computer terminals like automatic teller machines (ATM's); point-of-sale (POS) terminals, not mechanically operated - hand-held computers (PDA's) This class excludes: - repair and maintenance of carrier equipment modems, see 9512$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9512,'Repair of communication equipment', $$This class includes: - repair and maintenance of communications equipment such as: - cordless telephones - cellular phones - carrier equipment modems - fax machines - communications transmission equipment (e.g. routers, bridges, modems) - two-way radios - commercial TV and video cameras$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9521,'Repair of consumer electronics', $$This class includes: - repair and maintenance of consumer electronics: - television, radio receivers - video cassette recorders (VCR) - CD players - household-type video cameras$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9522,'Repair of household appliances and home and garden equipment', $$This class includes: - repair and servicing of household appliances - refrigerators, stoves, washing machines, clothes dryers, room air conditioners, etc. - repair and servicing of home and garden equipment - lawnmowers, edgers, snow- and leaf- blowers, trimmers, etc. This class excludes: - repair of hand held power tools, see 3312 - repair of central air conditioning systems, see 4322$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9523,'Repair of footwear and leather goods', $$This class includes: - repair and maintenance of footwear: - shoes, boots etc. - fitting of heels - repair and maintenance of leather goods: - luggage and the like$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9524,'Repair of furniture and home furnishings', $$This class includes: - reupholstering, refinishing, repairing and restoring of furniture and home furnishings including office furniture - assembly of self-standing furniture This class excludes: - installation of fitted kitchens, shop fittings and the like, see 4330$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9529,'Repair of other personal and household goods', $$This class includes: - repair of bicycles - repair and alteration of clothing - repair and alteration of jewellery - repair of watches, clocks and their parts such as watchcases and housings of all materials; movements, chronometers, etc. - repair of sporting goods (except sporting guns) - repair of books - repair of musical instruments - repair of toys and similar articles - repair of other personal and household goods - piano-tuning This class excludes: - industrial engraving of metals, see 2592 - repair of sporting and recreational guns, see 3311 - repair of hand held power tools, see 3312 - repair of time clocks, time/date stamps, time locks and similar time recording devices, see 3313$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9601,'Washing and (dry-) cleaning of textile and fur products', $$This class includes: - laundering and dry-cleaning, pressing etc., of all kinds of clothing (including fur) and textiles, provided by mechanical equipment, by hand or by self-service coin-operated machines, whether for the general public or for industrial or commercial clients - laundry collection and delivery - carpet and rug shampooing and drapery and curtain cleaning, whether on clients' premises or not - provision of linens, work uniforms and related items by laundries - diaper supply services This class also includes: - repair and minor alteration of garments or other textile articles when done in connection with cleaning This class excludes: - renting of clothing other than work uniforms, even if cleaning of these goods is an integral part of the activity, see 7730 - repair and alteration of clothing etc., as an independent activity, see 9529$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9602,'Hairdressing and other beauty treatment' , $$This class includes: - hair washing, trimming and cutting, setting, dyeing, tinting, waving, straightening and similar activities for men and women - shaving and beard trimming - facial massage, manicure and pedicure, make-up etc. This class excludes: - manufacture of wigs, see 3290$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9603,'Funeral and related activities', $$This class includes: - burial and incineration of human or animal corpses and related activities: - preparing the dead for burial or cremation and embalming and morticians' services - providing burial or cremation services - rental of equipped space in funeral parlours - rental or sale of graves - maintenance of graves and mausoleums This class excludes: - religious funeral service activities, see 9491$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9609,'Other personal service activities n.e.c.', $$This class includes: - activities of Turkish baths, sauna and steam baths, solariums, reducing and slendering salons, massage salons etc. - astrological and spiritualists' activities - social activities such as escort services, dating services, services of marriage bureaux - pet care services such as boarding, grooming, sitting and training pets - genealogical organizations - shoe shiners, porters, valet car parkers etc. - concession operation of coin-operated personal service machines (photo booths, weighing machines, machines for checking blood pressure, coin-operated lockers etc.) This class excludes: - veterinary activities, see 7500 - activities of fitness centers, see 9311$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9700,'Activities of households as employers of domestic personnel', $$This class includes: - activities of households as employers of domestic personnel such as maids, cooks, waiters, valets, butlers, laundresses, gardeners, gatekeepers, stable-lads, chauffeurs, caretakers, governesses, babysitters, tutors, secretaries etc. It allows the domestic personnel employed to state the activity of their employer in censuses or studies, even though the employer is an individual. The product produced by this activity is consumed by the employing household. This class excludes: - provision of services such as cooking, gardening etc. by independent service providers (companies or individuals), see ISIC class according to type of service$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
9810,'Undifferentiated goods-producing activities of private households for own use', $$This class includes: - undifferentiated subsistence goods-producing activities of households, i.e., the activities of households that are engaged in a variety of activities that produce goods for their own subsistence. These activities include hunting and gathering, farming, the production of shelter and clothing and other goods produced by the household for its own subsistence. If households are also engaged in the production of marketed goods, they are classified to the appropriate goods-producing industry of ISIC. If households are principally engaged in a specific goods-producing subsistence activity, they are classified to the appropriate goods-producing industry of ISIC.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9820,'Undifferentiated service-producing activities of private households for own use', $$This class includes: - undifferentiated subsistence services-producing activities of households, i.e. the activities of households that are engaged in a variety of activities that produce services for their own subsistence. These activities include cooking, teaching, caring for household members and other services produced by the household for its own subsistence. If households are also engaged in the production of multiple goods for subsistence purposes, they are classified to the undifferentiated goods-producing subsistence activities of households.$$ 
);

INSERT INTO "isic_class" (code,name,description) VALUES (
	9900,'Activities of extraterritorial organizations and bodies', $$This class includes: - activities of international organizations such as the United Nations and the specialized agencies of the United Nations system, regional bodies etc., the International Monetary Fund, the World Bank, the World Customs Organization, the Organisation for Economic Co-operation and Development, the Organization of Petroleum Exporting Countries, the European Communities, the European Free Trade Association etc. This class also includes: - activities of diplomatic and consular missions when being determined by the country of their location rather than by the country they represent$$ 
);

