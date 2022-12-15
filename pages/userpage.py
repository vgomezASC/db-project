'''
Kyle Timmermans (kt2578), Vicente Gomez (vg994)
Prof. Stoyanovich
Principles of Database Systems
Final Project

userpage.py
'''

import os
import psycopg2
import pandas as pd
import streamlit as st
from PIL import Image
from configparser import ConfigParser


# Connect to db (from demo.py)
def get_config(filename="database.ini", section="postgresql"):
    parser = ConfigParser()
    parser.read(filename)
    return {k: v for k, v in parser.items(section)}


# Query db (from demo.py)
def query_db(sql: str):
    db_info = get_config()
    conn = psycopg2.connect(**db_info)
    cur = conn.cursor()
    cur.execute(sql)
    data = cur.fetchall()
    column_names = [desc[0] for desc in cur.description]
    conn.commit()
    cur.close()
    conn.close()
    df = pd.DataFrame(data=data, columns=column_names)
    return df


# Insert into db
def insert_db(sql: str):
    db_info = get_config()
    conn = psycopg2.connect(**db_info)
    cur = conn.cursor()
    cur.execute(sql)
    conn.commit()
    cur.close()
    conn.close()


# Set username
# User would only see front end and would not be able to create a temp.dat
# unless they had access to the backend
f = open("temp.dat", "r")
username = f.read()
#os.remove("temp.dat")

st.set_page_config(page_title=f"Home | {username}", page_icon="assets/favicon.ico", initial_sidebar_state="collapsed", layout="wide")
logo = Image.open('assets/SteamDB.png')
col4, col5, col6 = st.columns(3, gap='large')
# Friends List, Send Friend Request
with col4:
    st.markdown(f"<h3 style='text-align: left;'>Friends List</h3>", unsafe_allow_html=True)
    with st.form("my_form1"):
        friends_data = query_db(f"SELECT DISTINCT username, game_name FROM users as U "
                                f"JOIN user_inventory AS UI ON UI.owner_id = U.uid "
                                f"JOIN users_friend AS UF ON (UF.sender_username = '{username}' OR "
                                f"UF.receiver_username = '{username}') "
                                f"WHERE username != '{username}' ORDER BY username;")

        friends_data = friends_data.values.tolist()
        final_data = pd.DataFrame(columns=["Friend", "Game(s) Owned"])
        # Following for-loop logic: Get all games of one friend until we hit the next friend,
        # then do that friend's games, and so on...
       
        # For each list of user and game
        for i in range(len(friends_data)):
            # Until new friend
            temp_friend = friends_data[i][0]
            # For each friend's games
            games = []
            j = i
            while friends_data[j][0] == temp_friend:
                games.append(friends_data[j][1])
                j = j + 1
                # If we get to the end, don't go further
                if j == len(friends_data):
                    break
            if temp_friend in final_data.Friend.values:
                continue
            else:
                final_data.loc[i] = [str(temp_friend), ', '.join(games)]

        # https://docs.streamlit.io/knowledge-base/using-streamlit/hide-row-indices-displaying-dataframe
        hide_table_row_index = """
                    <style>
                    thead tr th:first-child {display:none}
                    tbody th {display:none}
                    </style>
        """

        st.markdown(hide_table_row_index, unsafe_allow_html=True)

        st.table(final_data)

        refresh = st.form_submit_button("Refresh Friends List")
        if refresh:
            print("yo")


    st.write("")


    # Don't show ourselves and don't show people we've already friended
    with st.form("my_form2"):
        possible_friends = []
        try:
            get_users = query_db(f"SELECT S.sender_username, SUM(S.count) FROM "
                                 f"(SELECT sender_username, count(*) "
                                 f"FROM users_friend "
                                 f"WHERE sender_username != '{username}' AND receiver_username != '{username}' "
                                 f"GROUP BY sender_username "
                                 f"UNION "
                                 f"SELECT receiver_username, count(*) "
                                 f"FROM users_friend "
                                 f"WHERE sender_username != '{username}' AND receiver_username != '{username}' "
                                 f"GROUP BY receiver_username) S "
                                 f"GROUP BY S.sender_username "
                                 f"ORDER BY SUM(S.count) DESC")

            for i in range(len(get_users["sender_username"].tolist())):
                possible_friends.append(str(get_users["sender_username"][i]) + " - " + str(get_users["sum"][i]) + " friend(s)")
        except Exception as e:
            print(e)
            # No friends in DB yet
            pass

        try:
            zero_friends = query_db(f"SELECT username FROM users "
                                    f"WHERE username != '{username}' "
                                    f"EXCEPT "
                                    f"SELECT sender_username FROM users_friend "
                                    f"EXCEPT "
                                    f"SELECT receiver_username FROM users_friend "
                                    f"ORDER BY username;")

            for j in range(len(zero_friends["username"].tolist())):
                possible_friends.append(str(zero_friends["username"][j]) + " - 0 friend(s)")
        except:
            print(2)
            pass

        st.markdown(f"<h3 style='text-align: left;'>Add Friends</h3>", unsafe_allow_html=True)
        option = st.selectbox("--Find friends--", tuple(possible_friends))
        submitted = st.form_submit_button("Send Friend Request")
        if submitted:
            option = option.split(' ', 1)[0]
            get_uids = query_db(f"SELECT U1.uid AS num1, U2.uid AS num2 "
                                f"FROM users U1, users U2 WHERE U1.username = '{username}' "
                                f"AND U2.username = '{option}';")
            uid_sender, uid_receiver = get_uids["num1"].tolist()[0], get_uids["num2"].tolist()[0]
            insert_db(f"INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) "
                      f"VALUES ('{uid_sender}', '{uid_receiver}', '{username}', '{option}');")
            st.success(f"{option} added as a friend!", icon="🎉")

# Logo, Welcome, Inventory
with col5:
    st.image(logo)
    st.markdown(f"<h1 style='text-align: center;'>Hello, {username}!</h1>", unsafe_allow_html=True)
    st.write("")
    st.markdown(f"<h1 style='text-align: center;'>Inventory</h1>", unsafe_allow_html=True)

# Marketplace, List of Websites
with col6:
    st.markdown(f"<div style='text-align: right;'>Marketplace</div>", unsafe_allow_html=True)
    st.write("")
    st.markdown(f"<div style='text-align: right;'>Publisher Websites</div>", unsafe_allow_html=True)
