api_nci <- structure(
  list(
    record_id = c(1, 1),
    redcap_event_name = c("Baseline", "End"),
    nachos = structure(
      c("Yes", "Yes"),
      label = "Have you ever eaten nachos?",
      class = c("labelled", "character")
    ),
    treat = structure(
      c(TRUE, TRUE),
      label = "I use nachos to treat a medical condition (other than hunger).",
      class = c("labelled", "logical")
    ),
    treating = structure(
      c("Other", "Other"),
      label = "What is the primary problem that nachos are treating?",
      class = c("labelled", "character")
    ),
    othercondition = structure(
      c("Anxiety", "Anxiety"),
      label = "What other condition?",
      class = c("labelled", "character")
    ),
    last = structure(
      c("I ate nachos in the last year.", "I am currently eating nachos."),
      label = "When did you last eat nachos?",
      class = c("labelled", "character")
    ),
    traveled = structure(
      c("Yes", "Yes"),
      label = "Have you traveled somewhere specifically to get nachos?",
      class = c("labelled", "character")
    ),
    miles = structure(
      c(3115, 3115),
      label = "What is the farthest distance (in miles) you have traveled to get nachos? A calculator to convert kilometers to miles is here.",
      class = c("labelled", "numeric")
    ),
    now = structure(
      c("Yes", "Yes"),
      label = "Are you currently craving nachos?",
      class = c("labelled", "character")
    ),
    strong = structure(
      c(74, 90),
      label = "How extreme is your current nacho craving?",
      class = c("labelled", "numeric")
    ),
    ingredients___1 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Chips",
      class = c("labelled", "character")
    ),
    ingredients___2 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Yellow cheese",
      class = c("labelled", "character")
    ),
    ingredients___3 = structure(c("Unchecked", "Checked"),
      label = "What ingredients do you currently crave?: Orange cheese",
      class = c("labelled", "character")
    ),
    ingredients___4 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: White cheese",
      class = c("labelled", "character")
    ),
    ingredients___5 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Meat",
      class = c("labelled", "character")
    ),
    ingredients___6 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Beans",
      class = c("labelled", "character")
    ),
    ingredients___7 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Tomatoes",
      class = c("labelled", "character")
    ),
    ingredients___8 = structure(
      c("Checked", "Checked"),
      label = "What ingredients do you currently crave?: Peppers",
      class = c("labelled", "character")
    ),
    cheese = structure(
      c("5 Love it", "5 Love it"),
      label = "The cheesy goodness",
      class = c("labelled", "character")
    ),
    crunch = structure(
      c("5 Love it", "5 Love it"),
      label = "The crunchy goodness",
      class = c("labelled", "character")
    ),
    bean = structure(
      c("5 Love it", "5 Love it"),
      label = "The beany goodness",
      class = c("labelled", "character")
    ),
    guacamole = structure(
      c("5 Love it", "5 Love it"),
      label = "The guacamole goodness",
      class = c("labelled", "character")
    ), jalapeno = structure(
      c("5 Love it", "5 Love it"),
      label = "The jalapeno goodness",
      class = c("labelled", "character")
    ),
    meat = structure(
      c("5 Love it", "5 Love it"),
      label = "The meaty goodness",
      class = c("labelled", "character")
    ),
    life = structure(
      c(
        "They helped me cure my hunger.",
        "They make me feel happy."
      ),
      label = "How have nachos changed your life?",
      class = c("labelled", "character")
    ),
    nci_complete = structure(c("Complete", "Complete"),
      label = "Complete?...29",
      class = c("labelled", "character")
    )
  ),
  row.names = c(NA, -2L),
  class = "data.frame"
)


manual_export <- structure(
  list(
    record_id =
      structure(
        c(1L, 1L, 1L, 1L, 1L),
        label = "Record ID",
        class = c("labelled", "integer")
      ),
    redcap_event_name =
      structure(
        c(
          "baseline_arm_1", "day_1_arm_1", "day_2_arm_1", "day_3_arm_1",
          "end_arm_1"
        ),
        label = "Event Name",
        class = c("labelled", "character")
      ),
    concented =
      structure(
        c(1L, NA, NA, NA, NA),
        label = "Can we ask you some questions?",
        class = c("labelled", "integer")
      ),
    enrollment_complete =
      structure(
        c(2L, NA, NA, NA, NA),
        label = "Complete?",
        class = c("labelled", "integer")
      ),
    nachos =
      structure(
        c(1L, NA, NA, NA, 1L),
        label = "Have you ever eaten nachos?",
        class = c("labelled", "integer")
      ),
    treat =
      structure(
        c(1L, NA, NA, NA, 1L),
        label = "I use nachos to treat a medical condition (other than hunger).",
        class = c("labelled", "integer")
      ),
    treating = structure(
      c(3L, NA, NA, NA, 3L),
      label = "What is the primary problem that nachos are treating?",
      class = c("labelled", "integer")
    ),
    othercondition = structure(
      c("Anxiety", "", "", "", "Anxiety"),
      label = "What other condition?",
      class = c("labelled", "character")
    ),
    last = structure(
      c(5L, NA, NA, NA, 1L),
      label = "When did you last eat nachos?",
      class = c("labelled", "integer")
    ),
    traveled = structure(
      c(1L, NA, NA, NA, 1L),
      label = "Have you traveled somewhere specifically to get nachos?",
      class = c("labelled", "integer")
    ),
    miles = structure(
      c(3115L, NA, NA, NA, 3115L),
      label = "What is the farthest distance (in miles) you have traveled to get nachos? A calculator to convert kilometers to miles is here.",
      class = c("labelled", "integer")
    ),
    now = structure(
      c(1L, NA, NA, NA, 1L),
      label = "Are you currently craving nachos?",
      class = c("labelled", "integer")
    ),
    strong = structure(
      c(74L, NA, NA, NA, 90L),
      label = "How extreme is your current nacho craving?",
      class = c("labelled", "integer")
    ),
    ingredients___1 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Chips)",
      class = c("labelled", "integer")
    ),
    ingredients___2 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Yellow cheese)",
      class = c("labelled", "integer")
    ),
    ingredients___3 = structure(
      c(0L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Orange cheese)",
      class = c("labelled", "integer")
    ),
    ingredients___4 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=White cheese)",
      class = c("labelled", "integer")
    ),
    ingredients___5 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Meat)",
      class = c("labelled", "integer")
    ),
    ingredients___6 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Beans)",
      class = c("labelled", "integer")
    ),
    ingredients___7 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Tomatoes)",
      class = c("labelled", "integer")
    ),
    ingredients___8 = structure(
      c(1L, NA, NA, NA, 1L),
      label = "What ingredients do you currently crave? (choice=Peppers)",
      class = c("labelled", "integer")
    ),
    cheese = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The cheesy goodness",
      class = c("labelled", "integer")
    ),
    crunch = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The crunchy goodness",
      class = c("labelled", "integer")
    ),
    bean = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The beany goodness",
      class = c("labelled", "integer")
    ),
    guacamole = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The guacamole goodness",
      class = c("labelled", "integer")
    ),
    jalapeno = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The jalapeno goodness",
      class = c("labelled", "integer")
    ),
    meat = structure(
      c(5L, NA, NA, NA, 5L),
      label = "The meaty goodness",
      class = c("labelled", "integer")
    ),
    life = structure(
      c(
        "They helped me cure my hunger.",
        "", "", "", "They make me feel happy."
      ),
      label = "How have nachos changed your life?",
      class = c("labelled", "character")
    ),
    nci_complete = structure(
      c(2L, NA, NA, NA, 2L),
      label = "Complete?",
      class = c("labelled", "integer")
    ),
    gad1 = structure(
      c(3L, 0L, NA, NA, NA),
      label = "1.  Feeling nervous, anxious, or on edge  ",
      class = c("labelled", "integer")
    ),
    gad2 = structure(
      c(3L, 1L, NA, NA, NA),
      label = "2.  Not being able to stop or control worrying  ",
      class = c("labelled", "integer")
    ),
    gad3 = structure(
      c(3L, 2L, NA, NA, NA),
      label = "3.  Worrying too much about different things  ",
      class = c("labelled", "integer")
    ),
    gad4 = structure(
      c(3L, 3L, NA, NA, NA),
      label = "4.  Trouble relaxing  ",
      class = c("labelled", "integer")
    ),
    gad5 = structure(
      c(0L, 2L, NA, NA, NA),
      label = "5.  Being so restless that its hard to sit still  ",
      class = c("labelled", "integer")
    ),
    gad6 = structure(
      c(1L, 1L, NA, NA, NA),
      label = "6.  Becoming easily annoyed or irritable  ",
      class = c("labelled", "integer")
    ),
    gad7 = structure(
      c(3L, 0L, NA, NA, NA),
      label = "7.  Feeling afraid as if something awful might happen  ",
      class = c("labelled", "integer")
    ),
    difficult = structure(
      c(1L, 0L, NA, NA, NA),
      label = "If you checked off any problems, how difficult have these made it for you to do your work, take care of things at home, or get along with other people? ",
      class = c("labelled", "integer")
    ),
    gad7_complete = structure(
      c(2L, 2L, NA, NA, NA),
      label = "Complete?",
      class = c("labelled", "integer")
    ),
    hama_patient_name = structure(
      c(NA, NA, NA, NA, NA),
      label = "Patient Name",
      class = c("labelled", "logical")
    ),
    hama_todays_date = structure(
      c(
        "2020-01-21", "2020-01-22", "2020-01-23", "2020-01-24", "2020-01-25"
      ),
      label = "Todays Date",
      class = c("labelled", "character")
    ),
    hama_1 = structure(
      c(3L, 1L, 2L, 3L, 0L),
      label = "1. ANXIOUS MOOD -Worries-Anticipates worst ",
      class = c("labelled", "integer")
    ),
    hama_2 = structure(
      c(3L, 3L, 2L, 3L, 0L),
      label = "2. TENSION-Startles-Cries easily-Restless-Trembling",
      class = c("labelled", "integer")
    ),
    hama_3 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "3. FEARS -Fear of the dark -Fear of strangers-Fear of being alone-Fear of animal",
      class = c("labelled", "integer")
    ),
    hama_4 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "4. INSOMNIA -Difficulty falling asleep or staying asleep -Difficulty with Nightmares",
      class = c("labelled", "integer")
    ),
    hama_5 = structure(
      c(1L, 0L, 0L, 2L, 0L),
      label = "5. INTELLECTUAL -Poor concentration-Memory Impairment",
      class = c("labelled", "integer")
    ),
    hama_6 = structure(
      c(0L, 0L, 1L, 2L, 0L),
      label = "6. DEPRESSED MOOD-Decreased interest in activities-Anhedoni-Insomnia",
      class = c("labelled", "integer")
    ),
    hama_7 = structure(
      c(1L, 0L, 0L, 2L, 0L),
      label = "7. SOMATIC COMPLAINTS: MUSCULAR-Muscle aches or pains-Bruxism",
      class = c("labelled", "integer")
    ),
    hama_8 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "8. SOMATIC COMPLAINTS: SENSORY-Tinnitus -Blurred vision",
      class = c("labelled", "integer")
    ),
    hama_9 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "9. CARDIOVASCULAR SYMPTOMS-Tachycardia -Palpitations-Chest Pain-Sensation of feeling faint",
      class = c("labelled", "integer")
    ),
    hama_10 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "10. RESPIRATORY SYMPTOMS-Chest pressure-Choking sensation-Shortness of Breath",
      class = c("labelled", "integer")
    ),
    hama_11 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "11. GASTROINTESTINAL SYMPTOMS-Dysphagia-Nausea or Vomiting-Constipation-Weight loss-Abdominal fullness",
      class = c("labelled", "integer")
    ),
    hama_12 = structure(
      c(1L, 0L, 1L, 3L, 0L),
      label = "12. GENITOURINARY SYMPTOMS-Urinary frequency or urgency-Dysmenorrhea -Impotence",
      class = c("labelled", "integer")
    ),
    hama_13 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "13. AUTONOMIC SYMPTOMS-Dry Mouth-Flushing-Pallor-Sweating",
      class = c("labelled", "integer")
    ),
    hama_14 = structure(
      c(0L, 0L, 0L, 0L, 0L),
      label = "14. BEHAVIOR AT INTERVIEW-Fidgets-Tremor-Paces",
      class = c("labelled", "integer")
    ),
    hama_score = structure(
      c(8L, 4L, 5L, 15L, 0L),
      label = "TOTAL SCORE:",
      class = c("labelled", "integer")
    ), hamilton_anxiety_scale_hama_complete = structure(
      c(2L, 2L, 2L, 2L, 2L),
      label = "Complete?",
      class = c("labelled", "integer")
    ),
    redcap_event_name.factor = structure(
      1:5,
      levels = c("Baseline", "Day 1", "Day 2", "Day 3", "End"),
      class = "factor"
    ), concented.factor = structure(
      c(1L, NA, NA, NA, NA),
      levels = c("Yes", "No"),
      class = "factor"
    ),
    enrollment_complete.factor = structure(
      c(3L, NA, NA, NA, NA),
      levels = c("Incomplete", "Unverified", "Complete"),
      class = "factor"
    ),
    nachos.factor = structure(
      c(1L, NA, NA, NA, 1L),
      levels = c("Yes", "No"),
      class = "factor"
    ), treat.factor = structure(
      c(1L, NA, NA, NA, 1L),
      levels = c("True", "False"),
      class = "factor"
    ),
    treating.factor = structure(
      c(3L, NA, NA, NA, 3L),
      levels = c("Asthma", "Cancer", "Other"),
      class = "factor"
    ),
    last.factor = structure(
      c(5L, NA, NA, NA, 1L),
      levels = c(
        "I am currently eating nachos.",
        "I ate nachos earlier today.", "I ate nachos this week.",
        "I ate nachos in the last month.", "I ate nachos in the last year.",
        "I ate nachos more than a year ago."
      ),
      class = "factor"
    ),
    traveled.factor = structure(
      c(1L, NA, NA, NA, 1L),
      levels = c("Yes", "No"),
      class = "factor"
    ),
    now.factor = structure(
      c(1L, NA, NA, NA, 1L),
      levels = c("Yes", "No"),
      class = "factor"
    ),
    ingredients___1.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    ingredients___2.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    ingredients___3.factor = structure(
      c(1L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ), ingredients___4.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    ingredients___5.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ), ingredients___6.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    ingredients___7.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    ingredients___8.factor = structure(
      c(2L, NA, NA, NA, 2L),
      levels = c("Unchecked", "Checked"),
      class = "factor"
    ),
    cheese.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    crunch.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    bean.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    guacamole.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    jalapeno.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    meat.factor = structure(
      c(5L, NA, NA, NA, 5L),
      levels = c("1 Dont like", "2", "3 Neutral", "4", "5 Love it"),
      class = "factor"
    ),
    nci_complete.factor = structure(
      c(3L, NA, NA, NA, 3L),
      levels = c("Incomplete", "Unverified", "Complete"),
      class = "factor"
    ),
    gad1.factor = structure(
      c(4L, 1L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days", "Over half the days",
        "Nearly every day"
      ),
      class = "factor"
    ),
    gad2.factor = structure(
      c(4L, 2L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days",
        "Over half the days", "Nearly every day"
      ),
      class = "factor"
    ),
    gad3.factor = structure(
      c(4L, 3L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days", "Over half the days",
        "Nearly every day"
      ),
      class = "factor"
    ),
    gad4.factor = structure(
      c(4L, 4L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days", "Over half the days",
        "Nearly every day"
      ),
      class = "factor"
    ),
    gad5.factor = structure(
      c(1L, 3L, NA, NA, NA),
      levels = c(
        "Not at all sure",
        "Several days", "Over half the days", "Nearly every day"
      ),
      class = "factor"
    ),
    gad6.factor = structure(
      c(2L, 2L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days", "Over half the days",
        "Nearly every day"
      ),
      class = "factor"
    ),
    gad7.factor = structure(
      c(4L, 1L, NA, NA, NA),
      levels = c(
        "Not at all sure", "Several days", "Over half the days",
        "Nearly every day"
      ),
      class = "factor"
    ),
    difficult.factor = structure(
      c(2L, 1L, NA, NA, NA),
      levels = c(
        "Not difficult at all", "Somewhat difficult", "Very difficult",
        "Extremely difficult"
      ),
      class = "factor"
    ),
    gad7_complete.factor = structure(
      c(3L, 3L, NA, NA, NA),
      levels = c("Incomplete", "Unverified", "Complete"),
      class = "factor"
    ),
    hama_1.factor = structure(
      c(4L, 2L, 3L, 4L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_2.factor = structure(
      c(4L, 4L, 3L, 4L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_3.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_4.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_5.factor = structure(
      c(2L, 1L, 1L, 3L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_6.factor = structure(
      c(1L, 1L, 2L, 3L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_7.factor = structure(
      c(2L, 1L, 1L, 3L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_8.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_9.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_10.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_11.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_12.factor = structure(
      c(2L, 1L, 2L, 4L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_13.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hama_14.factor = structure(
      c(1L, 1L, 1L, 1L, 1L),
      levels = c("0 (Not present)", "1", "2", "3", "4 (Severe)"),
      class = "factor"
    ),
    hamilton_anxiety_scale_hama_complete.factor = structure(
      c(3L, 3L, 3L, 3L, 3L),
      levels = c("Incomplete", "Unverified", "Complete"),
      class = "factor"
    )
  ),
  row.names = c(NA, -5L),
  class = "data.frame"
)

api_nci_target <- structure(
  list(
    What = c(
      "Chips", "Yellow cheese", "Orange cheese", "White cheese", "Meat",
      "Beans", "Tomatoes", "Peppers"
    ),
    Count = c(2, 2, 1, 2, 2, 2, 2, 2)
  ),
  row.names = c(NA, -8L),
  class = c(
    "tbl_df", "tbl", "data.frame"
  )
)

test_that("api export choose all works", {
  expect_equal(make_choose_all_table(api_nci, "ingr"), api_nci_target)
})


test_that("manual export choose all works", {
  expect_equal(manual_export |> 
                 select(starts_with("ingr")) |> 
                 select(-ends_with("or")) |> 
                 make_choose_all_table("ingr"), 
               api_nci_target)
})
