package nl.vpro.poms.followchanges;

import nl.vpro.api.client.frontend.NpoApiClients;
import nl.vpro.api.client.utils.NpoApiMediaUtil;
import nl.vpro.domain.api.Deletes;
import nl.vpro.domain.api.MediaChange;
import nl.vpro.domain.api.Order;
import nl.vpro.util.CountedIterator;

import java.time.Duration;
import java.time.Instant;

import static nl.vpro.util.Env.PROD;

/**
 * @author Michiel Meeuwissen
 * @since ...
 */
public class Main {


	public static void main(String[] argv) throws Exception {
		NpoApiClients clients = NpoApiClients
            .configured(PROD)
            .build();
		NpoApiMediaUtil mediaUtil = NpoApiMediaUtil.builder()
            .clients(clients)
            .build();
		Instant start = Instant.now().minus(Duration.ofMinutes(10));
        String mid = null;
        while(true) {

			try (CountedIterator<MediaChange> changes = mediaUtil.changes(null, false, start, mid, Order.ASC, null, Deletes.ID_ONLY)) {
				while (changes.hasNext()) {
					MediaChange change = changes.next();
					if (!change.isTail()) {
						System.out.println(change);
					} else {

					}
					start = change.getPublishDate();
					mid = change.getMid();
				}
				//log.info("sleeping");
				Thread.sleep(1000L);
			}
		}

	}
}
