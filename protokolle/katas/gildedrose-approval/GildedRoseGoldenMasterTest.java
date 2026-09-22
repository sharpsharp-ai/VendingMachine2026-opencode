package de.sharpsharp.gildedrose;

import java.util.ArrayList;
import java.util.List;

import org.approvaltests.Approvals;
import org.junit.Test;

public class GildedRoseGoldenMasterTest {

    private static final String[] NAMES = {
        "Aged Brie",
        "Backstage passes to a TAFKAL80ETC concert",
        "Sulfuras, Hand of Ragnaros",
        "+5 Dexterity Vest",
        "Conjured Mana Cake"
    };

    private static final int[] SELL_IN = {-1, 0, 1, 4, 5, 6, 9, 10, 11, 15};
    private static final int[] QUALITY = {0, 1, 2, 48, 49, 50, 80};

    @Test
    public void oneDay() {
        List<Item> items = new ArrayList<>();
        for (String name : NAMES) {
            for (int sellIn : SELL_IN) {
                for (int quality : QUALITY) {
                    items.add(new Item(name, sellIn, quality));
                }
            }
        }

        GildedRose.with(items.toArray(new Item[0])).updateQuality();
        Approvals.verifyAll("items", items.toArray(new Item[0]));
    }
}
